# encoding: utf-8


class CsvTeamsReport    ## change to CsvPackageTeamsReport - why? why not?


def initialize( pack )
  @pack = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )
end


def build_summary
  ###
  ## todo - add count for seasons by level !!!!!
  ##   e.g. level 1 - 25 seasons, 2 - 14 seasons, etc.

  ## find all teams and generate a map w/ all teams n some stats
  teams = SportDb::Struct::TeamUsage.new
  levels = Hash.new(0)   ## keep a counter of levels usage (more than one level?)

  season_entries = @pack.find_entries_by_season
  season_entries.each do |season_entry|
    season_dir   = season_entry[0]
    season_files = season_entry[1]    ## .csv (data)files

    season_files.each_with_index do |season_file,i|
      ## note: assume last directory is the season (season folder)
      season = File.basename( File.dirname( season_file ) )   # get eg. 2011-12
      puts "  season=>#{season}<"

      season_file_basename = File.basename( season_file, '.csv' )    ## e.g. 1-bundesliga, 3a-division3-north etc.
      ## assume first char is a letter for the level!!!!
      ##
      level = season_file_basename[0].to_i
      ##  use to_i -why? why not?  -keep level as a string?
      ## check if level 0 - no integer - why? why not?

      levels[level] += 1   ## keep track of level usage

      matches   = CsvMatchReader.read( @pack.expand_path( season_file ) )

      teams.update( matches, season: season, level: level )
    end
  end



  buf = ''
  buf << "## Teams\n\n"

  ary = teams.to_a

  buf << "```\n"
  buf << "  #{ary.size} teams:\n"

  ary.each_with_index do |t,j|
    buf << ('  %5s  '   % "[#{j+1}]")
    if PRINT_TEAMS[t.team]   ## add marker e.g. (*) for pretty print team name
      team_name_with_marker = "**#{t.team}**"    ## add (*) - why? why not?
    else
      team_name_with_marker = "#{t.team} (???)"
    end
    buf << ('%-30s  '   % team_name_with_marker)
    buf << (':: %4d matches in ' % t.matches)
    buf << ('%3d seasons' % t.seasons.size)

    ## note: only add levels breakdown if levels.size greater (>1)
    ##  note: use "global" levels tracker
    if levels.size > 1

      buf << " / #{t.levels.size} levels - "
      ## note: format levels in aligned blocks (10-chars wide)
      levels.each do |level_key,_|
         level = t.levels[ level_key ]
         if level
           level_buf = "#{level_key} (#{level.seasons.size})"
           buf << level_buf
           buf << " " * (10-level_buf.length)    ## fill up to 10
         else
           buf << "   x "
           buf << " " * 5
         end
      end
    end

    buf << "\n"
  end
  buf << "```\n"
  buf << "\n\n"


  ## show list of teams without known pretty print name
  ## show details
  buf << "### Pretty Print Teams\n\n"

  names = []
  ary = teams.to_a
  ary.each do |t|
    names << t.team     if PRINT_TEAMS[t.team].nil?
  end
  names = names.sort   ## sort from a-z

  buf << "Unknown / Missing / ??? (#{names.size}):\n\n"
  buf << "#{names.join(', ')}\n"
  buf << "\n\n"


  ## for easy update add cut-n-paste code snippet
  buf << "```\n"
  names.each do |name|
    buf << "  '#{name}' => '',\n"
  end
  buf << "```\n\n"



  ## show details
  buf << "### Season\n\n"

  ary = teams.to_a
  ary.each do |t|
    buf << "- "
    if PRINT_TEAMS[t.team]   ## add marker e.g. (*) for pretty print team name
      team_name_with_marker = "**#{t.team}**"    ## add (*) - why? why not?
    else
      team_name_with_marker = "#{t.team} (???)"
    end
    buf << "#{team_name_with_marker} - #{t.seasons.size} seasons in #{t.levels.size} levels\n"
    levels.each do |level_key,_|
       level = t.levels[ level_key ]
       if level
         buf << "  - #{level_key} (#{level.seasons.size}): "
         buf << level.seasons.sort.reverse.join(' ')
         buf << "\n"
       end
    end
  end
  buf << "\n"

  buf
end # method build_summary


def save( path )
  File.open( path, 'w:utf-8' ) do |f|
    f.write build_summary
  end
end

end # class CsvTeamsReport
