# encoding: utf-8



module SportDb
  module Importer

  class Country
    ## built-in countries for (quick starter) auto-add
    COUNTRIES = {    ## rename to AUTO or BUILTIN_COUNTRIES or QUICK_COUNTRIES - why? why not?
      eng: ['England',     'ENG'],     ## title/name, code
      fr:  ['France',      'FRA'],
      at:  ['Austria',     'AUT'],
      de:  ['Deutschland', 'DEU'],   ## use fifa code or iso?
    }

def self.find( key )   ## e.g. key = 'eng' or 'de' etc.

   key = key.to_s   ## allow passing in of symbol (e.g. :fr instead of 'fr')

   country = WorldDb::Model::Country.find_by( key: key )
   if country.nil?
     ### check quick built-tin auto-add country data
     data = COUNTRIES[ key.to_sym ]
     if data.nil?
       puts "** unknown country for key >#{key}<; sorry - add to COUNTRIES table"
       exit 1
     end

     name, code = data

     country = WorldDb::Model::Country.create!(
        key:  key,
        name: name,
        code: code,
        area: 1,
        pop:  1
     )
   end
   pp country
   country
end
end # class Country



### add season
class Season

def self.find( key )  ## e.g. key = '2017-18'
  ## todo/fix:
  ##   always use 2017/18
  ##    use search and replace to change / to - or similar!!!
  key = key.tr( '-', '/' )  ## change 2017-18 to 2017/18
  ## check for 2017/2018  change to 2017/18
  if key.length == 9
    key = "#{key[0..3]}/#{key[7..8]}"
  end

  season = SportDb::Model::Season.find_by( key: key )
  if season.nil?
     season = SportDb::Model::Season.create!(
       key:   key,
       title: key
     )
  end
  pp season
  season
end
end # class Season



class League
## built-in countries for (quick starter) auto-add
LEAGUES = {    ## rename to AUTO or BUILTIN_LEAGUES or QUICK_LEAGUES  - why? why not?
  en: 'English Premier League',
  fr: 'Ligue 1',
  at: 'Österr. Bundesliga',
  de: '1. Bundesliga',
  'de.2': '2. Bundesliga',
}


### add league
def self.find( key )  ## e.g. key = 'en' or 'en.2' etc.
  ##  en,    English Premier League
  league = SportDb::Model::League.find_by( key: key )
  if league.nil?
     ### check quick built-tin auto-add league data
     data = LEAGUES[ key.to_sym ]
     if data.nil?
       puts "** unknown league for key >#{key}<; sorry - add to LEAGUES table"
       exit 1
     end

     name = data

     league = SportDb::Model::League.create!(
        key:   key,
        title: name,  # e.g. 'English Premier League'
     )
  end
  pp league
  league
end
end # class League


end # module Importer
end # module SportDb





def find_teams( team_names, country: )
  recs = []

  ## add/find teams
  team_names.each do |team_name|
    ## remove spaces too (e.g. Man City => mancity)
    ## remove dot (.) too e.g. St. Polten => stpolten
    ##        amp (& too e.g. Brighton & Hove Albion FC = brightonhove...
    ##        numbers  1. FC Kaiserslautern:
    ## team_key  = team_name.downcase.gsub( /[0-9&. ]/, '' )
    ## fix: reuse ascify from sportdb

    ## remove all non-ascii a-z chars
    team_key  = team_name.downcase.gsub( /[^a-z]/, '' )


    puts "add team: #{team_key}, #{team_name}:"

    team = SportDb::Model::Team.find_by( title: team_name )
    if team.nil?
       team = SportDb::Model::Team.create!(
         key:   team_key,
         title: team_name,
         country_id: country.id
       )
    end
    pp team
    recs << team
  end

  recs  # return activerecord team objects
end


def find_event( league:, season: )
  ## add event
  ##  key = 'en.2017/18'
  event = SportDb::Model::Event.find_by( league_id: league.id, season_id: season.id  )
  if event.nil?
    ## quick hack/change later !!
    ##  start_at use year and 7,1 e.g. Date.new( 2017, 7, 1 )
    year = season.key[0..3].to_i  ## eg. 2017-18 => 2017
    event = SportDb::Model::Event.create!(
       league_id: league.id,
       season_id: season.id,
       start_at:  Date.new( year, 7, 1 )
     )
  end
  pp event
  event
end
