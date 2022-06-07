require_relative 'astrology_api'

userID = ENV["API_UID"]
apiKey = ENV["API_KEY"]

# make some dummy data in order to call vedic rishi api
# data = {
#     'sunSign'=> 'Taurus',
#     'risingSign'=> 'Gemini',
#     'partnerSunSign'=> 'Cancer',
#     'partnerRisingSign'=> 'Libra'
# }

# api name which is to be called
resource = "compatibility/aries/aries/cancer/cancer"

# instantiate VedicRishiClient class
ritesh = VRClient.new(userID, apiKey)

# call horoscope apis
responseData = ritesh.compatibilityCall(
  resource,
  # data['sunSign'],
  # data['risingSign'],
  # data['partnerSunSign'],
  # data['partnerRisingSign']
)

p responseData
