
require 'sportdb/config'



class League
  attr_reader   :key, :name, :country, :intl
  attr_accessor :alt_names

  def initialize( key:, name:, alt_names: [], country: nil, intl: false )
    @key       = key
    @name      = name
    @alt_names = alt_names
    @country   = country
    @intl      = intl
  end
  def intl?()      @intl == true; end
  def national?()  @intl == false; end



  ## todo/fix: (re)use helpers from clubs - how? why? why not?
  LANG_REGEX = /\[[a-z]{1,2}\]/   ## note also allow [a] or [d] or [e] - why? why not?
  def self.strip_lang( name )
    name.gsub( LANG_REGEX, '' ).strip
  end

  NORM_REGEX =  /[.'º\-\/]/
  ## note: remove all dots (.), dash (-), ', º, /, etc.
  ##         for norm(alizing) names
  def self.strip_norm( name )
    name.gsub( NORM_REGEX, '' )
  end

  def self.normalize( name )
    # note: do NOT call sanitize here (keep normalize "atomic" for reuse)

    ## remove all dots (.), dash (-), º, /, etc.
    name = strip_norm( name )
    name = name.gsub( ' ', '' )  # note: also remove all spaces!!!

    ## todo/fix: use our own downcase - why? why not?
    name = downcase_i18n( name )     ## do NOT care about upper and lowercase for now
    name
  end
end



class LeagueReader

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    recs = []
    last_rec = nil
    country  = nil    # last country
    intl     = false  # is international (league/tournament/cup/competition)

    txt.each_line do |line|
      line = line.strip

      next  if line.empty?
      break if line == '__END__'

      next if line.start_with?( '#' )   ## skip comments too

      ## strip inline (until end-of-line) comments too
      ##  e.g  ţ  t  ## U+0163
      ##   =>  ţ  t
      line = line.sub( /#.*/, '' ).strip


      next if line =~ /^={1,}$/          ## skip "decorative" only heading e.g. ========

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
          puts "** !! ERROR !! unsupported headin level; expected heading 1 for now only; sorry"
          pp line
          exit 1
        else
          puts "heading (#{heading_level}) >#{heading}<"
          last_heading = heading
          ## map to country or international / int'l
          if heading =~ /international|int'l/i
            country = nil
            intl    = true
          elsif heading =~ /\(([a-z]{2,3})\)/i
            country_code = $1
            intl         = false

            ## check country code - MUST exist for now!!!!
            country = SportDb::Import.config.countries[ country_code ]
            if country.nil?
              puts "!!! error [league reader] - unknown country with code >#{country_code}< - sorry - add country to config to fix"
              exit 1
            end
          else
            puts "** !! ERROR !! no match found for heading (expected country code or internationa):"
            pp line
            exit 1
          end
        end
      elsif line.start_with?( '|' )
            ## assume continuation with line of alternative names
            ##  note: skip leading pipe
            values = line[1..-1].split( '|' )   # team names - allow/use pipe(|)
            ## strip and  squish (white)spaces
            #   e.g. New York FC      (2011-)  => New York FC (2011-)
            values = values.map { |value| value.strip.gsub( /[ \t]+/, ' ' ) }
            puts "alt_names: #{values.join( '|' )}"

            last_rec.alt_names += values
      else
        ## assume "regular" line
        ##  check if starts with id  (todo/check: use a more "strict"/better regex capture pattern!!!)
        if line =~ /^([a-z0-9][a-z0-9.]*)[ ]+(.+)$/
          league_key  = $1
          ## strip and  squish (white)spaces
          league_name = $2.gsub( /[ \t]+/, ' ' ).strip

          puts "key: >#{league_key}<, name: >#{league_name}<"

          ## prepend country key/code if country present
          ##   todo/fix: only auto-prepend country if key/code start with a number (level) or incl. cup
          ##    why? lets you "overwrite" key if desired - use it - why? why not?
          league_key = "#{country.key}.#{league_key}"   if country

          rec = League.new( key:     league_key,
                            name:    league_name,
                            country: country,
                            intl:    intl)
          recs << rec
          last_rec = rec
        else
          puts "** !! ERROR !! missing key for (canonical) league name"
          exit 1
        end
      end
      ## pp line
    end
    recs
  end # method parse

end # class LeagueReader






class LeagueIndex


  def initialize
    @leagues         = []   ## leagues by canonical name
    @leagues_by_name = {}
    @errors          = []
  end

  attr_reader :errors
  def errors?() @errors.empty? == false; end

  def mappings()   @leagues_by_name; end   ## todo/check: rename to index or something - why? why not?
  def leagues()    @leagues.values;  end


  ## helpers from club - use a helper module for includes - why? why not?
  def strip_lang( name ) League.strip_lang( name ); end
  def normalize( name )  League.normalize( name ); end



  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## puts "adding:"
      ## pp rec
      ### step 1) add canonical name
      @leagues << rec

      ## step 2) add all names (canonical name + alt names + alt names (auto))
      names = [rec.name] + rec.alt_names
      more_names = []

      names += more_names
      ## check for duplicates - simple check for now - fix/improve
      ## todo/fix: (auto)remove duplicates - why? why not?
      count      = names.size
      count_uniq = names.uniq.size
      if count != count_uniq
        puts "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s):"
        pp names
        pp rec
        exit 1
      end


      names.each_with_index do |name,i|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        name = strip_lang( name )
        norm = normalize( name )
        alt_recs = @leagues_by_name[ norm ]
        if alt_recs
          ## check if include club rec already or is new club rec
          if alt_recs.include?( rec )
            ## note: do NOT include duplicate club record
            ## todo/fix: check country might be nil (if intl)
            msg = "** !!! WARN !!! - (norm) name conflict/duplicate for league - >#{name}< normalized to >#{norm}< already included >#{rec.name}, #{rec.country.key}<"
            puts msg
            @errors << msg
          else
            ## todo/fix: check country might be nil (if intl)
            msg = "** !!! WARN !!! - name conflict/duplicate - >#{name}< will overwrite >#{alt_recs[0].name}, #{alt_recs[0].country.key}< with >#{rec.name}, #{rec.country.key}<"
            puts msg
            @errors << msg
            alt_recs << rec
          end
        else
          @leagues_by_name[ norm ] = [rec]
        end
      end
    end
  end # method add


  def match( name )
    ## todo/check: return empty array if no match!!! and NOT nil (add || []) - why? why not?
    name = normalize( name )
    @leagues_by_name[ name ]
  end

  def dump_duplicates # debug helper - report duplicate club name records
     @leagues_by_name.each do |name, leagues|
       if leagues.size > 1
         puts "#{leagues.size} matching leagues duplicates for >#{name}<:"
         pp leagues
       end
     end
  end
end # class LeagueIndex





if __FILE__ == $0

recs = LeagueReader.read( 'leagues.txt' )
pp recs

index = LeagueIndex.new
index.add( recs )
index.dump_duplicates

puts "** match AUT BL:"
pp index.match( 'AUT BL' )
pp index.match( 'aut bl' )

puts "** match CL:"
pp index.match( 'CL' )

puts "** match ENG PL:"
pp index.match( 'ENG PL' )

puts "** match ENG 1:"
pp index.match( 'ENG 1' )

end
