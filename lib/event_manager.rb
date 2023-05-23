require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phone_num(phone_num)
  phone_num = phone_num.tr('^0-9', '')
  if phone_num.length == 11 && phone_num[0] != 1
    '555-555-5555'
  elsif phone_num.length > 11 || phone_num.length < 10
    '555-555-5555'
  else
    phone_num = phone_num.to_s.rjust(10,'5')[0..9]
    [3, 7].each { |i| phone_num.insert(i, '-') }
    phone_num
  end
end

def get_date_object(date_time)
  Time.strptime(date_time, "%m/%d/%y %H:%M")
end

def most_popular_hour(hour_frequency)
  hour_frequency = hour_frequency.sort_by { |hr, freq| -freq }
  hour_frequency = hour_frequency.select { |item| item[1] == hour_frequency[0][1] }
  hour_frequency.map do |item|
    if item[0] < 13
      "#{item[0]} am"
    else
      "#{item[0] - 12} pm"
    end
  end
end

def most_popular_wkday(wkday_frequency)
  wkday_frequency = wkday_frequency.sort_by { |wkday, freq| -freq }
  wkday_frequency = wkday_frequency.select { |item| item[1] == wkday_frequency[0][1] }
  wkday_frequency.map do |item|
    case item[0]
    when 0
      "Sunday"
    when 1
      "Monday"
    when 2
      "Tuesday"
    when 3
      "Wednesday"
    when 4
      "Thursday"
    when 5
      "Friday"
    when 6
      "Saturday"
    end
  end
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'Event Manager Initialized!'

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents = CSV.open(
  'event_attendees.csv', 
  headers: true,
  header_converters: :symbol
)

hours = Hash.new(0)
wkdays = Hash.new(0)
contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  phone_num = clean_phone_num(row[:homephone])

  date = get_date_object(row[:regdate])
  hour = date.hour
  hours[hour] += 1

  wkday = date.wday
  wkdays[wkday] += 1

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
end

puts "The most popular hour(s) are: #{most_popular_hour(hours)}"
puts "The most popular weekday(s) are: #{most_popular_wkday(wkdays)}"
