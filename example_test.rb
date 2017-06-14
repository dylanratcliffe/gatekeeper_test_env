it { is_expected.to contain_file("/etc/fuckyeah").with(
  "ensure" => "file",
  "owner" => "root",
  "content" => "This absolutely must not change"
) }
