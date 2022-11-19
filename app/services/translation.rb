class Translation
  def initialize
    DeepL.configure do |config|
      config.auth_key = ENV['DEEPL_API_KEY']
      config.host = 'https://api-free.deepl.com' # Default value is 'https://api.deepl.com'
    end
  end

  def to_fr(text)
    DeepL.translate text, 'EN', 'FR'
  end
end

# translated_reports = reports.transform_values do |report|
#     report.transform_values { |item| Translation.new.to_fr(item).text }
# end

# p translated_reports
