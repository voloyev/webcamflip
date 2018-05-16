require 'hanami/cli'
require 'bundler/setup'

module WebcamFlip
  module CLI
    module Commands
      extend Hanami::CLI::Registry



      class Version < Hanami::CLI::Command
        desc 'Print version'

        def call(*)
          puts '1.0.0'
        end
      end

      class Run < Hanami::CLI::Command
        desc 'Flip camera'

        def kernel_module?
          `modinfo v4l2loopback`
          status = `$?`
          status.zero?
        end

        def call(*)
          if kernel_module?
            `ffmpeg -f v4l2 -i /dev/video0 -vf "vflip" -f v4l2 /dev/video1`
          else
            return 'v4l2loopback not present' 
          end
        end
      end
      register 'version', Version, aliases: ['v', '-v', '--version']
      register 'run', Run
    end
  end
end

Hanami::CLI.new(WebcamFlip::CLI::Commands).call
