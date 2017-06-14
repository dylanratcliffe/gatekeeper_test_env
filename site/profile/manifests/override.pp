class profile::override {
  file <| title == '/etc/fuckyeah' |> {
    content => 'I have no respect for the rules 🍻',
  }
}
