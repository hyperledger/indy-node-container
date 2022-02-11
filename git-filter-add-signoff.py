  # This file is supposed to be used as `python3 .../git-filter-repo.py --force --commit-callback "$(cat git-filter-add-signoff.py)"`
  # Mind to adapt the following before:
  usernames = [b"Sebastian Schmittner", b"HackMD", b"Artur A Philipp", b"debian"]
  email = b"sebastian.schmittner@eecc.de"
  # See https://htmlpreview.github.io/?https://github.com/newren/git-filter-repo/blob/docs/html/git-filter-repo.html#CALLBACKS
  # 
  # * Commit: `branch`, `original_id`, `author_name`, `author_email`,
  #         `author_date`, `committer_name`, `committer_email`,
  #         `committer_date`, `message`, `file_changes` (list of
  #         FileChange objects, each containing a `type`, `filename`,
  #         `mode`, and `blob_id`), `parents` (list of hashes or integer
  #         marks)
  if commit.author_name in usernames and b"Signed-off-by:" not in commit.message:
      commit.message = commit.message + b"\n\nSigned-off-by: " + usernames[0] + b" <" + email + b">"
