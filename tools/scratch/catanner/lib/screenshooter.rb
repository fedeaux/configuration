class Screenshooter
  attr_accessor :frequency

  def initialize(frequency: 0.5)
    self.frequency = frequency
  end

  def capture_screenshot
    timestamp = Time.now.strftime('%H%M%S_%3N')
    filename = "catan_#{timestamp}.png"
    filepath = File.join(Catanner::SCREENSHOTS_DIR, filename)

    # Platform-specific screenshot capture: MAC OS X only

applescript = <<~APPLESCRIPT
      tell application "System Events"
        tell application process "Catan Universe"
          properties of window 1
        end tell
      end tell
    APPLESCRIPT

    result = `osascript -e '#{applescript}' 2>&1`.strip
    puts "Result: #{result[0..200]}..." # First 200 chars
    puts "Success: #{result.include?('bounds') ? '✅ Contains bounds info' : '❌'}"
    return result

    if bounds_result =~ /\A\d+, \d+, \d+, \d+\z/
      x1, y1, x2, y2 = bounds_result.split(', ').map(&:to_i)
      width = x2 - x1
      height = y2 - y1

      ap [x1, y1, x2, y2]
    end


    # if RUBY_PLATFORM =~ /darwin/ # macOS
    #   system("screencapture -x #{filepath}")
    # elsif RUBY_PLATFORM =~ /linux/
    #   system("import -window root #{filepath}")
    # elsif RUBY_PLATFORM =~ /mingw|mswin/ # Windows
    #   require 'win32/screenshot'
    #   Win32::Screenshot::Take.of(:desktop).write(filepath)
    # end

    filepath if File.exist?(filepath)
  end

  def start
    loop do
      capture_screenshot
      sleep frequency
    end
  end
end
