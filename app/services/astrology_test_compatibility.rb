require_relative 'astrology_api'

userID = "619845"
apiKey = "0fe9a97cde1e13cefe57c49cf2643167"

# make some dummy data in order to call vedic rishi api
# data = {
#     'sunSign'=> 'Taurus',
#     'risingSign'=> 'Gemini',
#     'partnerSunSign'=> 'Cancer',
#     'partnerRisingSign'=> 'Libra'
# }

# api name which is to be called
resource = "compatibility/Taurus/Cancer/Gemini/Sagittarius"

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
