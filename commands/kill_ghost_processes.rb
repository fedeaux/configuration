class KillGhostProcesses
  def initialize
    @port = 3000
  end

  def kill
    `kill #{pids.join(' ')}`
  end

  def pids
    `sudo lsof -i tcp:#{@port}`.split("\n").map { |line| line.split(/\s+/) }.select do |line|
      line.first == 'ruby' && line[4] == 'IPv4'
    end.map { |line| line[1] }
  end
end

KillGhostProcesses.new.kill
