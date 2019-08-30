# encoding: utf-8


module Footballdata

def self.convert_season_by_season( country_key, sources,
                                   in_dir:,
                                   out_dir: )

  sources.each do |rec|
    season_key   = rec[0]   ## note: dirname is season e.g. 2011-12 etc.
    basenames    = rec[1]   ## e.g. E1,E2,etc.

    basenames.each do |basename|

      in_path = "#{in_dir}/#{season_key}/#{basename}.csv"

      league_key = FOOTBALLDATA_LEAGUES[basename]
      league_basename = league_key   ## e.g.: eng.1, fr.1, fr.2 etc.

      ## note: for de-deutschland, eng-england and es-espana
      ##   use long format e.g. 2010s/2011-12 etc
      if [:de, :eng, :es].include?( country_key )
        out_path = "#{out_dir}/#{SeasonUtils.directory(season_key, format: 'long')}/#{league_basename}.csv"
      else
        out_path = "#{out_dir}/#{SeasonUtils.directory(season_key)}/#{league_basename}.csv"
      end

      puts "in_path: #{in_path}, out_path: #{out_path}"
      ## CsvMatchConverter.convert( in_path, out_path )

      matches = CsvMatchReader.read( in_path )

      normalize_clubs( matches, country_key )

      CsvMatchWriter.write( out_path, matches )
    end
  end


  ###################################################
  ## (auto-) add / update SUMMARY.md report
  ## (auto-) add ) update README.md pages with standings

  ## pack = CsvPackage.new( "#{out_repo_path}/#{repo}" )

  ### todo:
  ## use all-in-one   pack.update_reports - why? why not?

  # summary_report = CsvSummaryReport.new( pack )
  # summary_report.write
  ## note: write same as summary.save( "#{out_root}/SUMMARY.md" )

  ## standings_writer = CsvStandingsWriter.new( pack )
  ## standings_writer.write
end # method convert_season_by_season



####
#  helper for normalize clubs
def self.normalize_clubs( matches, country_key )
  country_key = country_key.to_s  ## note: club struct uses string (not symbols); make sure we (always) use strings (otherwise compare fails)
  cache = {}   ## note: use a (lookup) cache for matched club names

  matches.each do |match|
    names = [match.team1, match.team2]
    clubs = []     # holds the match club 1 and club 2 (that is, team 1 and team 2)
    names.each do |name|
      club = cache[name]
      if club   ## bingo! found cached club match/entry
        clubs << club
      else
        m = SportDb::Import.config.clubs.match( name )
        if m.nil?
          ## todo/check: exit if no match - why? why not?
          puts "!!! *** ERROR *** no matching club found for >#{name}< - add to clubs setup"
          exit 1
        else
          if m.size == 1
            club = m[0]
            cache[name] = club   ## cache club match
            clubs << club
          else   ## assume more than one (>1) match
            ## resolve conflict - find best match - how?
            ## try match / filter by country
            m2 = m.select { |c| c.country.key == country_key }
            if m2.size == 1
              club = m2[0]
              cache[name] = club   ## cache club match
              clubs << club
            else
              puts "!!! *** ERROR *** no clubs or too many matching clubs found for country >#{country_key}< and >#{name}< - cannot resolve conflict / find best match (automatic):"
              pp m
              exit 1
            end
          end
        end
      end
    end # each name
    ## update names to use canonical names
    match.update( team1: clubs[0].name,
                  team2: clubs[1].name )
  end # each match
end  # method normalize_clubs


end # module Footballdata
