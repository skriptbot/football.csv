# encoding: utf-8


module Footballdata


def self.fetch( sources, out_dir: )
  download_base  = "http://www.football-data.co.uk/mmz4281"
  out_root = out_dir    # e.g."./dl/#{repo}"

  sources.each do |rec|
    dirname   = rec[0]
    basenames = rec[1]

    basenames.each do |basename|
      season_path = dirname[2..3]+dirname[5..6]  # e.g. 2008-09 becomse 0809 etc
      url = "#{download_base}/#{season_path}/#{basename}.csv"

      out_path = "#{out_root}/#{dirname}/#{basename}.csv"

      puts " url: >>#{url}<<, out_path: >>#{out_path}<<"

      txt = get( url )

      ## make sure parent folders exist
      FileUtils.mkdir_p( File.dirname(out_path) )   unless Dir.exists?( File.dirname( out_path ))
      File.open( out_path, 'w:utf-8' ) do |out|
          out.write txt
      end
    end
  end
end


def self.fetch_ii( basename, out_dir: )
  download_base  = "http://www.football-data.co.uk/new"
  out_root = out_dir     # e.g. "./dl"

  url = "#{download_base}/#{basename}.csv"
  out_path = "#{out_root}/#{basename}.csv"

  puts " url: >>#{url}<<, out_path: >>#{out_path}<<"

  txt = get( url )

  ## make sure parent folders exist
  FileUtils.mkdir_p( File.dirname(out_path) )   unless Dir.exists?( File.dirname( out_path ))
  File.open( out_path, 'w:utf-8' ) do |out|
      out.write txt
  end
end


def self.get( url )
  worker = Fetcher::Worker.new
  response = worker.get( url )

  if response.code == '200'
    txt = response.body

## [debug] GET=http://www.football-data.co.uk/mmz4281/0405/SC0.csv
##    Encoding::UndefinedConversionError: "\xA0" from ASCII-8BIT to UTF-8

    ## note: assume windows encoding (for football-data.uk)
    ##  convert to utf-8
    ##   use "Windows-1252" for input - why? why not?
    ##    see https://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/

    txt = txt.force_encoding( 'ISO-8859-1' )
    txt = txt.encode( 'UTF-8' )

    ## fix: newlines - always use "unix" style"
    txt = txt.gsub( "\r\n", "\n" )
    txt
  else
    puts " *** !!!! HTTP error #{response.code} - #{resonse.message}"
    exit 1
  end
end


end # module Footballdata
