require 'net/http'
require 'dotenv/load'
require 'json'

API_KEY  = ENV['STEAM_KEY']

def get_friends_list
    url = URI.parse("http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=#{API_KEY}&steamid=76561198053563189&relationship=friend")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    p JSON.parse(res.body)
end

get_friends_list