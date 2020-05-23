package main

blacklist = [
  "openjdk"
]

ignorelist = [
  "shutdown",
  "service",
  "ps",
  "free",
  "top",
  "kill",
  "mount",
  "ifconfig",
  "nano",
  "vim"
]

image_tag_list = [
    "latest",
    ""
]
get_users(in) = users {
    users := [y | y := in[x].Value[0]; lower(in[x].Cmd) == "user"]
}

#Looking for latest docker image used
warn[msg] {
    input[i].Cmd == "from"
    val := split(input[i].Value[0], ":")
    count(val) == 1
    msg = sprintf("Always tag the version of an image explicitly: %s", [val])
}

#Looking for latest docker image used
warn[msg] {
    input[i].Cmd == "from"
    val := split(input[i].Value[0], ":")
    contains(lower(val[1]), image_tag_list[_])
    msg = sprintf("Do not use latest tag with image: %s", [input[i].Value])
}

#Looking for blacklisted images
deny[msg] {
  input[i].Cmd == "from"
  val := input[i].Value
  contains(val[i], blacklist[_])

  msg = sprintf("blacklisted image found %s", [val])
}

#Looking for sudo
deny[msg] {
    input[i].Cmd == "run"
    val := concat(" ", input[i].Value)
    contains(lower(val), "sudo")
    msg = sprintf("Avoid using 'sudo' command: %s", [val])
}

#DL3002
deny[msg] {
    users := get_users(input)
    users[count(users)-1] == "root"
    msg := "[DL3002] Last user should not be root"
}

#DL3002
deny[msg] {
    users := get_users(input)
    count(users) == 0
    msg := "[DL3002] User should be set"
}
#DL3001
deny[msg] {
  input[i].Cmd == "run"
  val := input[i].Value
  contains(val[_], blacklist[_])

  msg = sprintf("blacklisted commands found %s", [val])
}