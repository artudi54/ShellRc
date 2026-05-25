# .sudo_as_admin_successful
echo 'Defaults !admin_flag' | sudo tee /etc/sudoers.d/$USER-shellrc-config >/dev/null

