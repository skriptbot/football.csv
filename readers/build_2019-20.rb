require 'sportdb/readers'


SOURCE_DIR = '../../../openfootball'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SOURCE_DIR}/clubs"
SportDb::Import.config.leagues_dir = "#{SOURCE_DIR}/leagues"


def setup( dbname='football' )
  db_file = "./#{dbname}.db"
  File.delete( db_file )  if File.exist?( db_file )

  SportDb.connect( adapter:  'sqlite3',
                   database: db_file )
  SportDb.create_all       ## build database schema (tables, indexes, etc.)


  ## turn on logging to console
  ActiveRecord::Base.logger = Logger.new( STDOUT )
end


def read( name, season: '2019/20' )
  ## SportDb.read( "#{SOURCE_DIR}/#{name}", season: season )
  pack = SportDb::Package.new( "#{SOURCE_DIR}/#{name}" )
  ## pack.read_clubs_props
  pack.read( season: season )
end



LEAGUE_TO_BASENAME = {
  'eng.1' => 'en.1',      ## keep en.1 for now - why? why not?
}

def gen_json( league_key, opts={} )

  out_root = opts[:out_root] || './o'

  league = SportDb::Model::League.find_by_key!( league_key )

  league.events.each do |event|
     puts "** event:"
     pp event.title
     pp event.season
     pp event.league
     puts "teams.count: #{event.teams.count}"
     puts "rounds.count: #{event.rounds.count}"

     clubs = []
     event.teams.each do |team|
       clubs << { key:  team.key, name: team.title, code: team.code }
     end

     hash_clubs = {
      name: event.title,
      clubs: clubs
     }

     pp hash_clubs


     rounds = []
     event.rounds.each do |round|
       matches = []
       round.games.each do |game|
         matches << { date: game.play_at.strftime( '%Y-%m-%d'),
                      team1: {
                        key:  game.team1.key,
                        name: game.team1.title,
                        code: game.team1.code
                      },
                      team2: {
                        key:  game.team2.key,
                        name: game.team2.title,
                        code: game.team2.code
                      },
                      score1: game.score1,
                      score2: game.score2 }
       end

       rounds << { name: round.title, matches: matches }
     end

     hash_matches =  {
       name: event.title,
       rounds: rounds
     }

     pp hash_matches


     ## build path e.g.
     ##  2014-15/at.1.clubs.json

     ##  -- check for remapping (e.g. add .1); if not found use league key as is
     league_basename = LEAGUE_TO_BASENAME[ event.league.key ] || event.league.key

     season_basename = event.season.title.sub('/', '-')  ## e.g. change 2014/15 to 2014-15


     out_dir   = "#{out_root}/#{season_basename}"
     ## make sure folders exist
     FileUtils.mkdir_p( out_dir ) unless Dir.exists?( out_dir )

     File.open( "#{out_dir}/#{league_basename}.clubs.json", 'w' ) do |f|
       f.write JSON.pretty_generate( hash_clubs )
     end

     File.open( "#{out_dir}/#{league_basename}.json", 'w' ) do |f|
       f.write JSON.pretty_generate( hash_matches )
     end
  end

end



setup()
read( 'england' )
## read( 'austria' )

## gen_json( 'eng.1' )

## check for club props update
pp SportDb::Model::Team.find_by( code: 'MUN' )
## pp SportDb::Model::Team.find_by( title: 'Manchester United FC' )
