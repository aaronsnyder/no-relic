require 'ApacheLogRegex'
require 'json'

settings_file = File.read('config.json')
@collector_settings = JSON.parse(settings_file)

if @collector_settings
	for logfile in @collector_settings["logfiles"]

		format = '%h %l %u %t \"%r\" %>s %b'
		parser = ApacheLogRegex.new(format)	

		puts "Reading logfile location: #{logfile}"
		
		@response_codes = Hash.new(0)
		File.open(logfile, "r") do |file_handle|	
			file_handle.each_line do |event|
				
				parsed_event = parser.parse(event)
				
				@response_codes[parsed_event["%>s"]] += 1
			end
		end
		puts "Response statistics: #{@response_codes}"
	end
else
	puts "no logfiles configured"
end

