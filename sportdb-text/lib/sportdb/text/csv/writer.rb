# encoding: utf-8


class CsvMatchWriter

def self.write( path, matches )
  out = File.new( path, 'w:utf-8' )    ## fix: use utf8!!!!!!!
  out <<  "Round,Date,Team 1,FT,HT,Team 2\n"  # add header


  ## track match played for team
  played = Hash.new(0)

  matches.each_with_index do |match,i|

    if i < 2
       puts "[#{i}]:" + match.inspect
    end

    values = []

    if match.round     ## optional: might be nil
      values << match.round
    else
      values << "?"   ## match round missing - fix - add!!!!
    end


    ## note:
    ##   as a convention add all auto-calculated values in ()
    ##  e.g. weekday e.g. (Fri), weeknumber (22), matches played (2), etc.

    ## for easier double-checking of rounds and dates
    ##  (auto-)add weekday and weeknumber
    ##  todo/fix: weeknumber - use +1  (do NOT start with 0 - why? why not)
    if match.date
      ## note: assumes string for now e.g. 2018-11-22
      date = Date.strptime( match.date, '%Y-%m-%d' )
      values << date.strftime( '(%a) %-d %b %Y (%-W)' )   ## print weekday e.g. Fri, Sat, etc.
    else
      values << '?'
    end

    team1_played = played[match.team1] += 1
    team2_played = played[match.team2] += 1

    values << "#{match.team1} (#{team1_played})"

    if match.score1 && match.score2
      values << match.score_str
    else
      # no (or incomplete) full time score; add empty
      values << '?'
    end

    if match.score1i && match.score2i
      values << match.scorei_str
    else
      # no (or incomplete) half time score; add empty
      values << '?'
    end

    values << "#{match.team2} (#{team2_played})"


    out << values.join( ',' )
    out << "\n"
  end

  out.close
end
end # class CsvMatchWriter
