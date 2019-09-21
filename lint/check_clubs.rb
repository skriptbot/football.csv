
require 'sportdb/config'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"



LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries




class ClubLintReader   ### todo/check: rename to EventConfigReader/TournamentReader/etc. - find a better name? why? why not?

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    headings = []
    clubs   = nil   ## current clubs array   ## note: same as headings[-1][1]

    txt.each_line do |line|
      line = line.strip

      next  if line.empty?
      break if line == '__END__'

      next if line.start_with?( '#' )   ## skip comments too

      ## strip inline (until end-of-line) comments too
      ##  e.g  ţ  t  ## U+0163
      ##   =>  ţ  t
      line = line.sub( /#.*/, '' ).strip


      next if line =~ /^[ =]+$/          ## skip "decorative" only heading e.g. ========; note: allow spaces to e.g. = = = =
      next if line =~ /^[ -]+$/         ## skip "decorative"  line e.g. --- or - - - -

      ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
      ##  todo/check:  allow ===  Text  =-=-=-=-=-=   too - why? why not?
      if line =~ /^(={1,})       ## leading ======
                  ([^=]+?)      ##  text   (note: for now no "inline" = allowed)
                  =*            ## (optional) trailing ====
                  $/x
        heading_marker = $1
        heading_level  = $1.length   ## count number of = for heading level
        heading        = $2.strip

        puts "heading #{heading_level} >#{heading}<"

        if heading_level != 1
          puts "** !! ERROR !! unsupported heading level; expected heading 1 for now only; sorry"
          pp line
          exit 1
        else
          puts "heading (#{heading_level}) >#{heading}<"
          ## todo/fix:  strip/remove season if present first - why? why not?
          clubs = []
          headings <<  [ heading, clubs ]
        end
      else
        ##  assume club name
        ## check if starts with number e.g.   1   Liverpool
        line = line.sub( /^[0-9]{1,2}[ ]+/, '' )   if line =~ /^[0-9]{1,2}[ ]+/

        ## note if line starts with pipe (just delete for now)
        ##   in future bundle together names!!!!
        line = line.sub( '|', '' )   if line.start_with?( '|' )


        if clubs
          ## check for multiple clubs entries / names
          values = line.split( '|' )
          values = values.map {|value| value.strip }
          ## add one-by-one to preserve array reference
          values.each do |value|
            clubs << value
          end
        else
          puts "** !!! ERROR !!! heading missing / expected; cannot add club; sorry - add heading"
          exit 1
        end
      end
    end
    headings
  end # method parse

end # class ClubLintReader




def check_clubs( names, country )   ## todo/fix: add international or league flag?
  missing_clubs = []

  names.each do |name|

    m = CLUBS.match_by( name: name, country: country )

    if m.nil?
      ## (re)try with second country - quick hacks for known leagues
      ##  todo/fix: add league flag to activate!!!
      m = CLUBS.match_by( name: name, country: COUNTRIES['wal'])  if country.key == 'eng'
      m = CLUBS.match_by( name: name, country: COUNTRIES['nir'])  if country.key == 'ie'
      m = CLUBS.match_by( name: name, country: COUNTRIES['mc'])   if country.key == 'fr'
      m = CLUBS.match_by( name: name, country: COUNTRIES['li'])   if country.key == 'ch'
      m = CLUBS.match_by( name: name, country: COUNTRIES['ca'])   if country.key == 'us'
    end

    if m.nil?
       puts "** !!! WARN !!! no match for club >#{name}<"

       missing_clubs << name
    elsif m.size > 1
       puts "** !!! ERROR !!! too many matches (#{m.size}) for club >#{name}<:"
       pp m
       exit 1
    else
       # bingo; match
    end
  end
  missing_clubs
end



def check_clubs_by_countries( countries )
  missing_clubs = []

  countries.each do |rec|
    heading     = rec[0]
    club_names  = rec[1]

    if heading =~ %r{ \(([a-z]{2,3})\) }x
      country = COUNTRIES[ $1 ]
      if country.nil?
        puts "!!! error [club reader] - unknown country code >#{$1}< in >#{heading}< - sorry - add country to config to fix"
        exit 1
      end

      missing = check_clubs( club_names, country )
      missing_clubs << [heading, missing]
    else
      puts "!!! error [club reader] - unknown country format  >#{heading}< - sorry - two or three-letter lowercase letter eg (ab) or (abc) expected"
      exit 1
    end
  end
  missing_clubs
end



def check_clubs_by_leagues( leagues )
  missing_clubs = []

  leagues.each do |rec|
    heading     = rec[0]
    club_names  = rec[1]

    m = LEAGUES.match( heading )
    if m.nil?
      puts "!!! error [club reader] - unknown league  >#{heading}< - sorry - add league to config to fix"
      exit 1
    else   ## todo/fix: check for more than one match error too!!!
      league = m[0]
    end

    missing = check_clubs( club_names, league.country )
    missing_clubs << [heading, missing]
  end
  missing_clubs
end





def find_datafiles( path, pattern )
  datafiles = []
  candidates = Dir.glob( "#{path}/**/*.txt" ) ## check all txt files as candidates
  pp candidates
  candidates.each do |candidate|
    datafiles << candidate    if pattern.match( candidate )
  end

  pp datafiles
  datafiles
end