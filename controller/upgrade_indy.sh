#!/bin/bash

print_error() {
    >&2 echo -e "\033[1;31mError:\033[0m $1"
}

if [[ -z "$NODE_CONTAINER" ]]; then
    print_error "Missing node container name environment variable"
    exit 22
fi

if [[ -z "$CONTROLLER_CONTAINER" ]]; then
    print_error "Missing controller container name environment variable"
    exit 22
fi

# use docker if no other engine has been specified
ENGINE="${ENGINE:-docker}"

# make sure the selected container engine is supported
if [[ "$ENGINE" != "podman" && "$ENGINE" != "docker" ]]; then
    print_error "Unsupported container engine: $ENGINE"
    exit 22
fi

for container in $NODE_CONTAINER $CONTROLLER_CONTAINER; do
    inspect="$ENGINE container inspect $container --format "

    if [[ "$($inspect '{{.State.Status}}')" != "running" ]]; then
        echo "Skipping upgrade because the container '$container' is not running"
        continue
    fi

    # get name of the image used by the container
    image_name="$($inspect '{{.Config.Image}}')"
    if [[ -z "$image_name" ]]; then
        print_error "Container $container does not exist"
        exit 22
    fi

    # save the creation date of the image
    image_date="$($ENGINE image inspect "$image_name" --format '{{.Created}}')"

    # try to pull a new image
    output="$($ENGINE image pull "$image_name")"

    if [[ $? != 0 ]]; then
        print_error "$ENGINE pull failed: $output"
        exit 1
    fi

    # compare the old and new creation date to verify that a newer image has been pulled
    if [[ "$($ENGINE image inspect $image_name --format '{{.Created}}')" != "$image_date" && "$container" == "$NODE_CONTAINER" ]]; then
        # parse and save various container parameter to supply to the new one
        binds="-v $($inspect '{{join .HostConfig.Binds " -v "}}')"
        ports="$($inspect '{{range $k, $v := .NetworkSettings.Ports}}{{range $v}}{{print "-p " .HostIp ":" .HostPort ":" $k " "}}{{end}}{{end}}' | sed 's/:::/[::]:/g')"
        network="$($inspect '{{range $k, $v := .NetworkSettings.Networks}}{{$id := slice "'$($inspect {{.Id}})'" 0 12}}{{$aliases := join $v.Aliases " --network-alias "}}{{println "--network" $k "--ip" $v.IPAddress "--network-alias" $aliases "--network-alias" $id}}{{end}}' | head -n1)"
        restart="--restart $($inspect '{{.HostConfig.RestartPolicy.Name}}')"
        init="$($inspect '{{.HostConfig.Init}}' | sed 's/true/--init/g; /--init/!s/.*//')"
        $inspect '{{join .Config.Env "\n"}}' > /tmp/envs
        envs="$(if [ -s /tmp/envs ]; then echo "--env-file /tmp/envs"; else echo ""; fi)"
        $inspect '{{range $k,$v := .Config.Labels}}{{printf "%s=%s\n" $k $v}}{{end}}' | grep -v "^org.opencontainers.image" > /tmp/labels
        # patch image hash in the docker-compose labels
        sed -i "s/sha256.*/$($ENGINE image inspect docker --format '{{.Id}}')/g" /tmp/labels
        labels="$(if [ -s /tmp/labels ]; then echo "--label-file /tmp/labels"; else echo ""; fi)"

        output=$($ENGINE container create --name ${container}_new $binds $ports $network $init $restart $envs $labels $image_name) 1> /dev/null
        if [[ $? != 0 ]]; then
            print_error "failed to create new node container: $output"
            exit 1
        fi

        # exit bash script if any of the following fails
        set -e

        $ENGINE container stop $container 1> /dev/null
        $ENGINE container rm $container 1> /dev/null
        $ENGINE container rename ${container}_new $container 1> /dev/null
        $ENGINE container start $container 1> /dev/null

        rm /tmp/{envs,labels}
    else
        echo "$container image is up to date"
    fi
done

exit 0
