# encoding: utf-8

module SportDb
  module Import


def self.data_dir
  ## fix/todo: use SportDb::Import.root plus /config - why? why not?
  File.expand_path( "#{File.dirname(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))))}/config" )
end


class Configuration

  attr_accessor :team_mappings
  attr_accessor :teams

  attr_accessor :leagues



  def initialize

    ## unify team names; team (builtin/known/shared) name mappings
    ## cleanup team names - use local ("native") name with umlaut etc.
    recs = []
    %w(de fr mc es it pt nl be tr gr eng wal sco at mx).each do |country|
       recs += TeamReader.from_file( "#{Import.data_dir}/teams/#{country}.txt" )
    end

    ############################
    ## add team mappings
    ##   alt names to canonical pretty (recommended unique) name
    @team_mappings = {}

    recs.each do |rec|
       rec.alt_names.each do |alt_name|
         ## todo/fix: warn about duplicates (if key exits) ???????
         @team_mappings[ alt_name ] = rec.name
       end
    end

###
## reverse hash for lookup/list of "official / registered(?)"
##    pretty recommended canonical unique (long form)
##    team names


##
##  todo/fix: move to new TeamConfig class (for reuse) !!!!!!
    @teams = {}
    recs.each do |rec|
      @teams[ rec.name ] = rec
    end


    #####
    # add / read-in leagues config
    @leagues = LeagueConfig.new


    self  ## return self for chaining
  end
end # class Configuration




## lets you use
##   SportDb::Import.configure do |config|
##      config.hello = 'World'
##   end

def self.configure
  yield( config )
end

def self.config
  @config ||= Configuration.new
end

end   # module Import
end   # module SportDb
