# encoding: utf-8



module SportDb
  module Struct


class Match

  attr_reader :date,
              :team1,    :team2,   ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
              :score1,   :score2,    ## full time
              :score1i,  :score2i,   ## half time (first (i) part)
              :score1et, :score2et,  ## extra time
              :score1p,  :score2p,   ## penalty
              :winner,    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie
              :round     ## todo/fix:  use round_num or similar - for compat with db activerecord version? why? why not?


  def initialize( **kwargs )
    update( kwargs )  unless kwargs.empty?
  end

  def self.create( **kwargs )    ## keep using create why? why not?
    self.new.update( kwargs )
  end


  def update( **kwargs )
    ## note: check with has_key?  because value might be nil!!!
    @date    = kwargs[:date]     if kwargs.has_key? :date
    @team1   = kwargs[:team1]    if kwargs.has_key? :team1
    @team2   = kwargs[:team2]    if kwargs.has_key? :team2

    @round   = kwargs[:round]    if kwargs.has_key? :round
    ## note: (always) (auto-)convert round num (matchday) to integers
    @round   = @round.to_i       if @round


    @score1   = kwargs[:score1]    if kwargs.has_key? :score1
    @score1i  = kwargs[:score1i]   if kwargs.has_key? :score1i
    @score1et = kwargs[:score1et]  if kwargs.has_key? :score1et
    @score1p  = kwargs[:score1p]   if kwargs.has_key? :score1p

    @score2   = kwargs[:score2]    if kwargs.has_key? :score2
    @score2i  = kwargs[:score2i]   if kwargs.has_key? :score2i
    @score2et = kwargs[:score2et]  if kwargs.has_key? :score2et
    @score2p  = kwargs[:score2p]   if kwargs.has_key? :score2p

    ## note: (always) (auto-)convert scores to integers
    @score1   = @score1.to_i    if @score1
    @score1i  = @score1i.to_i   if @score1i
    @score1et = @score1et.to_i  if @score1et
    @score1p  = @score1p.to_i   if @score1p

    @score2   = @score2.to_i    if @score2
    @score2i  = @score2i.to_i   if @score2i
    @score2et = @score2et.to_i  if @score2et
    @score2p  = @score2p.to_i   if @score2p


    ## todo/fix:
    ##  gr-greece/2014-15/G1.csv:
    ##     G1,10/05/15,Niki Volos,OFI,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    ##

    ##  for now score1 and score2 must be present
    if @score1.nil? || @score2.nil?
      puts "*** missing scores for match:"
      pp kwargs
      ## exit 1
    end

    ## todo/fix: auto-calculate winner
    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie
    ### calculate winner - use 1,2,0
    if @score1 && @score2
       if @score1 > @score2
          @winner = 1
       elsif @score2 > @score1
          @winner = 2
       elsif @score1 == @score2
          @winner = 0
       else
       end
    else
      @winner = nil   # unknown / undefined
    end

    self   ## note - MUST return self for chaining
  end



  def over?()      true; end  ## for now all matches are over - in the future check date!!!
  def complete?()  true; end  ## for now all scores are complete - in the future check scores; might be missing - not yet entered


  def score_str    # pretty print (full time) scores; convenience method
    "#{@score1}-#{@score2}"
  end

  def scorei_str    # pretty print (half time) scores; convenience method
    "#{@score1i}-#{@score2i}"
  end

end  # class Match
end # module Struct

end # module SportDb
