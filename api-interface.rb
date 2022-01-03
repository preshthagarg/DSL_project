#!/usr/bin/env ruby
require 'httparty'
require 'json'
require_relative 'character'

$BASE_URL = 'http://localhost:3000'

def make_url(endpoint)
  "#{$BASE_URL}/api/#{endpoint}"
end

def class_url(classname)
  make_url("classes/#{classname.downcase}")
end

def get_json(endpoint)
  HTTParty.get(make_url(endpoint)).body
end

def parse_url(url)
  JSON.parse(HTTParty.get(url).body)
end

def get_parsed(endpoint)
  parse_url(make_url(endpoint))
end

def get_class_json(classname)
  get_parsed(class_url(classname))
end

# NOTE: We should probably refactor this stuff to take in JSON rather than a classname. That way we can save the json object we get and pass it in repeatedly. Actually, with local DP pings are cheap and we need to ping multiple pages, so this is fine.

# Bunch of utilities for filtering json, getting bits we need, etc.
def make_feature_list(classname)
  # TODO: Handle ASIs and class_specific stuff. I think ASIs are handled, since they're listed on the features page with links to the URL of the object as a feature
  url = class_url(classname)
  acc = [nil] # Starts with nil at position 0 because that way acc[i] represents features gained at level i, which is nice
  (1..20).to_a.each do |i|
    data = parse_url("#{url}/levels/#{i}")
    acc << data['features'].map do |feature|
      feature_data = parse_url("#{$BASE_URL}#{feature['url']}")
      feature_data.slice('name', 'desc', 'prerequisites', 'feature_specific')
    end
  end
  acc
end

def get_proficiencies(classname)
  results = parse_url("#{class_url classname}/proficiencies")['results']
  results.map { |i| i['name'] }
end

def get_proficiency_choices(classname)
  # Return a list of hashes
  data = parse_url(class_url(classname))['proficiency_choices']
  data.map do |item|
    choices = item['from'].map { |choice| choice['name'] }
    num = item['choose']
    Hash['num' => num, 'choices' => choices]
  end
end

def make_subclass_list(classname)
  results = parse_url("#{class_url classname}/subclasses")['results']
  # TODO
end

def caster?(classname)
  resp = HTTParty.get("#{class_url classname}/spellcasting").body
  !resp.empty?
end

def make_class(classname)
  # Make a class as an object and return it.
  # Strictly, this should be a classmethod.
  return DnDClass.new(Hash[:name => classname,
                           :caster => caster?(classname),
                           :proficiencies => get_proficiencies(classname),
                           :proficiency_choices => get_proficiency_choices(classname),
                           :levels => make_feature_list(classname),
                          ])
end

def make_subclass(classname, subclassname); end

x= make_class("warlock")
