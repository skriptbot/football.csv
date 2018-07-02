# encoding: utf-8



def build_team_usage_in_matches_txt( matches )

  teams = Hash.new( 0 )   ## default value is 0

  matches.each_with_index do |match,i|
    teams[ match.team1 ] += 1
    teams[ match.team2 ] += 1
  end

  teams
end


def find_teams_in_matches_txt( matches )

  teams = Hash.new( 0 )   ## default value is 0

  matches.each_with_index do |match,i|
    teams[ match.team1 ] += 1
    teams[ match.team2 ] += 1
  end

  pp teams

  ## note: only return team names (not hash with usage counter)
  teams.keys
end




def find_seasons_in_txt( path )

  seasons = Hash.new( 0 )   ## default value is 0

  csv = CSV.read( path, headers: true )

  csv.each_with_index do |row,i|
    puts "[#{i}] " + row.inspect  if i < 2

    season = row['Season']
    seasons[ season ] += 1
  end

  pp seasons

  ## note: only return season keys/names (not hash with usage counter)
  seasons.keys
end