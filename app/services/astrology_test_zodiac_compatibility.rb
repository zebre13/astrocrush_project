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
resource = "zodiac_compatibility/Aries/Cancer"

# instantiate VedicRishiClient class
ritesh = VRClient.new(userID, apiKey)

# call horoscope apis
responseData = ritesh.zodiac_compatibilityCall(
  resource,
  # data['sunSign'],
  # data['risingSign'],
  # data['partnerSunSign'],
  # data['partnerRisingSign']
)

p responseData
