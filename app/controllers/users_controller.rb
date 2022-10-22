require 'json'
require_relative '../services/astrology_api'

class UsersController < ApplicationController
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])

  ZODIAC = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
  LOGOS = { Sun: "☉ ", Moon: "☽ ", Mercury: "☿ ", Venus: "♀︎ ", Mars: "♂︎ ", Jupiter: "♃ ", Saturn: "♄ ", Uranus: "♅ ", Neptune: "♆ ", Pluto: "♇ " }
  SUN_REPORTS = {
    Aries: "Arians can be inspirational, courageous, enthusiastic, original, independent, impatient, aggressive, headstrong, selfish, self-centered, and impulsive. The Arian's energies are directed toward building a new individuality, thus all the Arian's energies are directed towards themself and what they want. An Arian likes roles where there leadership abilities are put on display. Arians have executive and organizing ability which is mainly directed in starting things. Sustaining projects is not their strength, but initiating projects is. The tendency to 'damn the torpedoes' and ram full-speed ahead must be controlled. Arians are capable of great accomplishments if they learn how to constructively use their abundant energies. Arians are naturally enthusiastic and are always ready for activity and competition. They are inspiring to others because of these tendencies. Ideas and creative projects seem to flow from them in a never-ending stream. They are full of energy and never lack courage. Because Arians can be pretty self-centered, they must remember that other people may have good ideas and can assume responsibility and leadership roles, too. The natural tendency for an Arian is to stand alone and do everything themself. But cooperation with others can be very effective in getting things done to the end rather than simply starting things and quitting before completion. Arians have a tendency to start a project, then to suddenly lose interest in it if progress is too slow or things have become too complicated.",
    Taurus: "Taureans are generally strong, quiet, deliberate, practical, exacting, determined, persistent, persevering, compassionate and loyal. They like getting their hands on their work, building things, and seeing the tangible, practical results of their effort. Routine work does not bother them as long as the end result in useful and serves some concrete purpose. Possessions and material things are usually of great significance to Taureans. This is because they don't feel emotionally secure unless they can see and touch the objects they own. This intense need to possess and enjoy with the senses can drive Taureans to be extremely productive or extremely acquisitive. Lesser evolved Taureans can treat people as objects or possessions, thus leading to difficulty in relationships. Taurus people work at a slower pace than most, but they always finish whatever projects they start. Because of this, they are reliable, trustworthy, careful and steadfast. They are better at sustaining what others have started rather than starting things themselves. Taureans can be lead, but never pushed. It takes a lot to make a Taurean mad, yet if they are pushed over the edge, well, all heck can break lose. Simply imagine an angry bull and you know what a Taurean is capable of when he is pushed too far. You know the saying about a bull in a china shop, right? When angered, Taureans need plenty of time to cool down. It is best to just leave them alone. You will know when things are out of their system. With anything Taureans need time to assimilate and mull things over. Don't rush them or push them.",
    Gemini: "Geminians are friendly, clever, talkative, versatile, curious, perceptive, intuitive, and logical. At times they can also be quite contradictory, restless, two-faced, critical, and impatient. Gemini people enjoy and need work that includes a great deal of variety. They love to do several things all at the same time, sometimes making them late for appointments. They abhor boredom. Geminians tend to flit from one experience to another, gathering in all types of information along the way, but seldom getting to the depth of any subject. They go broad and not deep. Persistence is not their strong suit. Gaining knowledge and disseminating it is their real talent. Hence, they make wonderful salespeople or teachers if they stick around long enough to get all the facts instead of only half the story. Even if they do not possess all the facts, since they are never at a loss for words, they will continue with their story as if they did have all the facts. It is important for a Geminian to seek intellectual satisfaction. Mental stagnation turns them off, so they read extensively and communicate widely in order to satisfy this longing for mental stimulation. This discontent can make them either very ambitious, or it can incline them to jump from one thing to another, searching for the greener grass which never appears. Geminians usually think quickly on their feet and have the ability to use the right words in any situation. They possess tremendous wit and a good sense of humor. Other people may have difficulty in keeping up with their rapid change of subjects.",
    Cancer: "Cancerians have a strange way of moving through life in a sideways manner, never approaching life head-on, but always from the side. They generally do not tackle anything straight away, but always from the flank. Emotionally, they are up one minute and down the next. These mood swings are sometimes difficult for others to understand and deal with. Cancerians are tenacious, sympathetic, industrious, sociable, thrifty and protective. They can also be argumentative, sensitive, emotional, martyr-like, intuitive, psychic, and patriotic. Cancerians respond to life through their emotions rather than through their minds. They tend to absorb the emotional vibrations of wherever they're at, so it is important to always be in positive environments. Because they live in their feelings, they unconsciously seek sympathy and attention and affection from others. They have a strong need to feel secure. Home and family bring the highest sense of security. Because of all this, they want to be first with those they love or they are very unhappy. Cancerians must learn to release their loved ones to live their own lives. Cancerians are well-known for changing — their minds, their moods, anything. Since they usually possess a slower moving life force, they are usually less active than others. In order to be active, they must first motivate their mind. In general, they dislike exercise. As a consequence, they may become out of shape and gain weight in later years.",
    Leo: "Leos are dignified, courageous, affectionate, powerful, generous, playful, optimistic, ambitious, loyal, and cheerful. On the negative side, though, they can be quite demanding, intolerant, domineering, lazy, closed-minded, and self-centered. They choose to do things that give them wide scope for creativity, organizing, and leadership. Although appearing strong on the outside, most Leos are inwardly sensitive and their feelings are easily hurt. When this occurs, they can turn on the object of their affection, when their pride is hurt. Leos have a decided flair for the dramatic and they enjoy telling stories, being the center of attention, having a good time, and running the show. Mean and cruel acts are generally beneath them, but they do not hesitate to use force when needed. No matter what their actions, they always have the belief that whatever they do is for the other person's benefit. If a Leo is angered, he immediately goes into his kingly role, 'mounting his throne' and quickly putting the opposition or challenger in their proper place. Leos literally roar at people when they are angry. But once their tirade is over, they forgive and forget and never hold a grudge.",
    Virgo: "Virgos desire purity and perfection in all they are and all they do. They are generally reserved, shy, analytical, discriminating, precise, industrious, systematic, considerate, punctual, and reliable. Virgos are hard workers who usually have a great deal of common sense and are practical, with a flair for detailed work. On the negative side, though, they can also be aloof, skeptical, picky, sarcastic, depressed, critical, pessimistic, whiny, and self-centered. Virgoans are happy when they can work with a lot of details, usually of a technical or analytical nature, in and for the service of others. They do not have to be the boss as service is more important than leadership. Virgoans have curious and inquiring minds, with keen analysis and excellent memories. They enjoy analyzing people, situations, and problems. They always want to know how, why, when and where. It is sometimes hard for a Virgo to relax because boredom is something they cannot stand. They want to be busy, either doing or learning. A Virgoan can generally be depended upon to fulfill a promise. They have a flair for organization and enjoy setting up schedules. There is an inborn love of order and harmony. They are always subconsciously seeking perfection in whatever they attempt. Because they push themselves so hard to be perfect, they have a tendency to look for perfection in others. If they find it lacking, they can become pretty critical and faultfinding.",
    Libra: "Librans like to weigh the pros and cons of a situation before they come to any conclusion. If carried too far, they get to the point where they can't come up with any conclusion, thus they can be very indecisive. They tip the scales one way, then the other, hoping to find the proper balance. Librans have an innate sense of fairness, though, and can be diplomatic, cooperative, helpful, idealistic, sociable, dependent, insincere, lazy and self-indulgent. Librans are happiest when in partnership or in situations where they can adjust or work with human relationships. Pleasant surroundings are important to them. Because Librans enjoy people and human interaction so much, they have a difficult time being alone. Because of this, they need to share their life with someone. Unfortunately, they have a tendency to be 'in love with love', because of their romantic and sentimental natures. Thus, they could rush into marriage without forethought and end up in a difficult relationship. Librans find it virtually impossible to remain emotionally stable if there is discord around them. This leads to their wanting peace at any price, which allows others to take advantage of them. They want to be liked by everyone, sometimes to their detriment.",
    Scorpio: "Two animals are used to represent Scorpio, the eagle and the scorpion. The eagle is capable of reaching great heights because he has mastered his lower nature and overcome his passions and the temptations of the sensual sphere. The eagle has risen above the physical world because he has regenerated himself. The scorpion, however, represents those who have not regenerated their thoughts and actions and are still living degenerate lives. They use their cunning and strike when least expected. These are the ones who satisfy their passions regardless of consequences.Scorpios in general are ambitious, efficient, courageous, resourceful and intuitive. But, they can also be jealous, sarcastic, resentful, stubborn, possessive and vindictive. Scorpio people enjoy impossible tasks. They like work that demands continued, determined effort and intense concentration. They are born detectives. Scorpio gives a strong will and determination to accomplish anything undertaken. Scorpios possess an analytical mind, strong intuition, reasoning powers, perception, long range planning ability, magnetism and energy. Scorpios have very definite opinions. These opinions can be so rigid that no amount of persuasion will make them change their minds. Scorpios make friends easily and give unwaveringly to them. In these relationships, they like to know what your plans are, but, because of their secretiveness, they do not necessarily want you to know what they are planning. They are capable of extreme self-sacrifice for those they love. If any of their loved ones are threatened in any way, they feel that they, too, are being threatened. This causes them to instinctively strike out, either verbally or physically.",
    Sagittarius: "Sagittarians tend to be idealistic, optimistic, dependable, open-minded, friendly, honest and versatile. But, they can also be tactless, irresponsible, showy, boastful, self-righteous, arrogant, quarrelsome, fanatical, dogmatic and dictatorial. Sagittarians like any work where foresight and a willingness to take a chance is offered, while at the same time, they try to avoid detailed work.Sagittarians are usually outspoken, sometimes to the point of bluntness. Simply blurting out their ideas and opinions is due to their never-ending search for truth and wisdom. Others think Sagittarians are pretty tactless and the statement that 'truth hurts' fits their way of thinking. Regardless of their undiplomatic remarks, others instinctively feel as if the Sagittarian means them no real harm and is only interested in raising their consciousness. Sagittarians love the outdoors, large animals, nature and sports. Some have reckless gambling tendencies and will bet it all on the drop of a hat. Travel and even long walks appeal to them because they make the Sagittarian feel free — and he needs to feel free. Sagittarians are philosophical and they want to understand the deeper issues and abstractions of life. They have a certain faith in higher things that generally always keeps them of an optimistic bent, no matter what difficulties are currently besetting them. They want to understand the meaning of life. This helps to keep them growing and expanding, which is something they need to do. This desire for expansion can cause them to overextend themselves with too many activities and to use up their energy too rapidly. They need to take intervals of rest to recuperate between projects.",
    Capricorn: "Capricorns have the desire to climb whatever mountains are necessary and to stand on their own two feet in order to work out their ambitions and their salvation. They are conservative, organized, methodical, traditional, responsible, honest, efficient, patient, practical, authoritative, disciplined, serious and goal-oriented. On the negative side they can be worried, pessimistic, retaliatory, suspicious, stubborn and intolerant. They are happiest in careers calling for organizing ability, integrity and perseverance. They have a fear of failure.Their quiet exterior makes Capricorns appear to be loners. They build a wall of reserve around them in order to protect themselves from the ill winds of the world around them. Nothing gets in the way of their plans and ambitions. They strive for security by holding fast to duty and responsibility. Work is very important to them and they do not take it lightly. Many Capricorns have an inferiority complex and this sometimes is what drives them so hard to succeed. They want to look good in front of the world. Capricorns like to plan their every move, weighing all the pros and cons of any issue in advance. They are dependable, particularly in a crisis. When asked, they give sound, practical advice. They are, as a rule, not aggressive people, and only express hostility as a defense when attacked. At times Capricorns can be very sensitive to hurts and feel alone as if no one understands them. A negative Capricorn will seek retribution for wrongs done him. Capricorns need people, but they have a tendency to isolate themselves from people due to their reserve and fear of being hurt. They can be very loyal to close friends and people they care about. Respect and recognition is important to them. Encouragement and praise are essential for motivating a Capricorn.",
    Aquarius: "Aquarians tend to be friendly, original, intuitive, broadminded, nonconforming, different, independent, freedom-loving, scientific, unusual, and helpful. They can also be impersonal, unpredictable, tactless, rebellious, unconventional, stubborn, rigid, radical, bohemian and eccentric. Aquarians like any work which calls for inventiveness and the detached application of special rules or formulae.Aquarians seek to share knowledge with others in order to bring about a better life for all. Group activity is their customary mode of operation. Helping others so they can help themselves appeals to an Aquarian. Aquarians are friendly, yet detached, they have warmth, yet they seem distant. Although appearing cold or aloof, they are not really indifferent to others. It's just that they are much more concerned with humanity as a whole rather than any one particular individual. Since Aquarians generally do not have large, pompous or stuffy egos, they rarely bother to exert themselves to win approval or compliments. Aquarians get excited about bringing new ideas and methods into old, traditional environments. They are philosophical, visionary and idealistic. Feelings of friendship drive them to try to improve the lot of everyone they can. Sometimes the people they want to help don't understand these new ways and react negatively toward them. Sometimes Aquarians are simply ahead of their time, although sometimes they are just cranks.",
    Pisces: "Pisceans are sympathetic, compassionate, unassuming, idealistic, intuitive, congenial, adaptable, psychic, emotional, creative, secretive, versatile, imaginative and self-sacrificing. They can also be impressionable, indecisive, self-pitying, hypersensitive and changeable. They need to serve others. Pisceans are sentimental and romantic in love. At times they expect too much from others and then feel hurt if the other person doesn't come through for them. They have a strong tendency to place their loved one on a pedestal. This leads to disillusionment when they discover their loved one has faults, too. The symbol for Pisces is two fish going in opposite directions connected by a cord. One fish represents the personality and the other represents the spirit. These two opposing forces operate within a Piscean, causing insecurity and indecisiveness. Handling these forces in a positive manner is very difficult for them. Some will seek to escape these pressures through eating, alcohol, drugs or other excesses. That is what one of the fish represents. The other fish represents the Piscean rising to great heights through self-denial, sacrifice and then ultimate attainment. Pisceans learn through suffering and they need to learn perseverance.Pisceans tend to absorb the information and environment around them. Thus it is important that they surround themselves with uplifting people and circumstances. Pisceans are creative, self-sufficient people whose minds are extremely active, due to their strong imagination, which they can sometimes get carried away with. They sense and feel things that others are not aware of."
  }

  def index
    mini_date = Date.today - (current_user.minimal_age * 365)
    max_date = Date.today - (current_user.maximum_age * 365)

    # selectionner les utilisateurs par preferences age / rayon / gender
    users_by_preference = User.where(gender: current_user.looking_for).where.not(id: current_user.id).where("(birth_date < ?)", mini_date).where("(birth_date > ?)", max_date)

    # Ne garder que les utilisateurs qui ont un score de match calculé avec moi
    users_with_score = users_by_preference.select do |user|
      user.affinity_scores.keys.include?(current_user.id)
    end

    # On rejette tous les users qui sont dans les matchs du current user.
    @users = users_with_score.reject do |user|
      Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
    end
  end

  def show
    @mate = User.find(params[:id])
    @mate_sun_report = SUN_REPORTS[@mate.sign.to_sym]
  end

  def astroboard
    @daily_horoscope = API_CALL.daily_horoscope(current_user.sign)
    @zodiac_compatibility = API_CALL.zodiac_compatibility(current_user.sign)
    @my_zodiac = create_zodiac
    @signs = [find_planets(1), find_planets(2), find_planets(3), find_planets(4), find_planets(5), find_planets(6), find_planets(7), find_planets(8), find_planets(9), find_planets(10), find_planets(11)]
  end

  private

  def create_zodiac
    cut = 0

    ZODIAC.each_with_index do |sign, index|
      cut = index if sign == current_user.rising.capitalize
    end
    ZODIAC.slice(cut..) + ZODIAC.slice(0..(cut - 1))
  end

  def find_planets(zodiac_index)
    hash_planets = current_user.planets
    planets = []
    data_to_display = {}
    hash_planets.each do |planet, hash|
      if @my_zodiac[zodiac_index] == hash[:sign]
        data_to_display["sign"] = hash[:sign]
        data_to_display["planet"] = planet.to_s.upcase
        data_to_display["house"] = hash[:house]
        data_to_display["logo"] = LOGOS[planet]
        planets << data_to_display
        data_to_display = {}
      end
    end
    return planets
  end

  # def update_index
  #   # 2. Utiliser current_user.search_perimeter ( a créer et migrer et mettre dans le signup et edit).
  #   users_by_preference = User.where(gender: current_user.looking_for).where.not(id: current_user.id)

  #   # 3. Puis exclure ceux avec qui j'ai déja matché ou que j'ai déja disliké (comme dans l'index controlleur de base).
  #   users_by_preference_not_swiped = users_by_preference.reject do |user|
  #     Match.where("(user_id = ?) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
  #     # Match.where("user_id = ? OR (mate_id = ? AND status IN ?)", current_user.id, current_user.id, [1, 2]).pluck(:mate_id, :user_id).flatten.include?(user.id)
  #   end

  #   # 4. Rassembler les utilisateurs préférés dont la distance entre leur coordonnées est inférieure ou égale à current_user.rayon
  #   users_in_perimeter = []
  #   users_by_preference_not_swiped.each do |mate|
  #     # calculer les distances avec chacun de ces utilisateur
  #     distance = calculate_distance( mate)
  #     if distance <= current_user.search_perimeter
  #       users_in_perimeter << user
  #     end
  #   end

  #   # 5. On vire ceux avec qui on a deja un score de match
  #   @users_without_score = @users_in_perimeter.reject do |user|
  #     user.affinity_scores.keys.include?(current_user.id)
  #   end
  #   # 6. En selectionner 10 au hasard
  #   ten_users = users_without_score.sample(10)

  #   # 7. calculer 10 nouveaux scores à partir des users obtenus
  #   calculate_scores(ten_users)
  # end

  # def calculate_distance(user)
  #   # TODO
  #   # current_user distance avec user
  # end

  # def calculate_scores(users)
  #     # user.API.match_percentage ETC TODO
  # end
end
