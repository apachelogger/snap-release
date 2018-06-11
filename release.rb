#!/usr/bin/env ruby

require 'json'
require 'tty/command'
require '/tooling/ci-tooling/lib/apt'
require '/tooling/ci-tooling/nci/lib/setup_repo'

NCI.setup_proxy!
Apt.install('snapcraft') || raise

# Host copies their credentials into our workspace, copy it to where
# snapcraft looks for them.
cfgdir = "#{Dir.home}/.config/snapcraft"
FileUtils.mkpath(cfgdir)
File.write("#{cfgdir}/snapcraft.cfg", File.read('snapcraft.cfg'))

snap = JSON.parse(File.read('/workspace/snap.json')).fetch('result')
name = snap.fetch('name')
revision = snap.fetch('revision')

TTY::Command.new.run('snapcraft', 'release', name, revision, 'stable')
