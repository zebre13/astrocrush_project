class Translation
  def initialize
    DeepL.configure do |config|
      config.auth_key = ENV['DEEPL_API_KEY']
      config.host = 'https://api.deepl.com' # When using free version: 'https://api-free.deepl.com'
    end
  end

  def to_fr(text)
    DeepL.translate text, 'EN', 'FR'
  end
end
