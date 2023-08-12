require 'net/http'
require 'dotenv/load'
require 'json'

API_KEY  = ENV['STEAM_KEY']
MY_STEAM_ID = "76561198053563189"

def get_friends_list
    url = URI.parse("http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=#{API_KEY}&steamid=#{MY_STEAM_ID}&relationship=all")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    JSON.parse(res.body)['friendslist']['friends']
end

def get_player_summaries(steam_id)
    url = URI.parse("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{API_KEY}&steamids=#{steam_id}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    JSON.parse(res.body)['response']['players'][0]
end

def get_owned_games(steam_id)
    url = URI.parse("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{API_KEY}&steamid=#{steam_id}&format=json&include_appinfo=true")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    JSON.parse(res.body)['response']['games']
end

friends_hash = Hash.new

get_friends_list.each do |friend|
    temp_array = Array.new
    friends_games = Array.new
    
    player_summary = get_player_summaries(friend['steamid'])
    p player_summary['personaname']

    owned_games = get_owned_games(player_summary['steamid'])
    
    unless owned_games.nil? 
        owned_games.each do |game|
            friends_games << game["name"]
        end
    end

    temp_array << player_summary['steamid']
    temp_array << friends_games

    friends_hash[player_summary['personaname']] = temp_array
end

p friends_hash