# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_autofill.rb


require 'helper'


class TestAutoFill < MiniTest::Test

  def test_fr
txt_i  =<<TXT
=====================================
= French Ligue 1 2014/15
=====================================

# Matches Retour


Journée 19

[Ven 19. Déc]
  20h30  RC Lens  2-0  OGC Nice
[Sam 20. Déc]
  17h00  Paris SG    0-0  Montpellier Hérault SC
  20h00  SM Caen     1-1  SC Bastia
         FC Lorient  1-2  FC Nantes
         FC Metz     0-1  AS Monaco FC
         Stade Rennais FC  1-3  Stade de Reims
         Toulouse FC  1-1  EA Guingamp
[Dim 21. Déc]
  14h00  Olympique de Marseille  2-1  LOSC Lille
  17h00  AS Saint-Étienne  3-0  Évian TG
  21h00  Girondins de Bordeaux  0-5  Olympique Lyonnais


Journée 38

[Sam 23. Mai]
  20h00  Girondins de Bordeaux - Montpellier Hérault SC
  20h00  SM Caen - Évian TG
  20h00  RC Lens - FC Nantes
  20h00  FC Lorient - AS Monaco FC
  20h00  Olympique de Marseille - SC Bastia
  20h00  FC Metz - LOSC Lille
  20h00  Paris SG - Stade de Reims
  20h00  Stade Rennais FC - Olympique Lyonnais
  20h00  AS Saint-Étienne - EA Guingamp
  20h00  Toulouse FC - OGC Nice

TXT


txt_ii =<<TXT
=====================================
= French Ligue 1 2014/15
=====================================

# Matches Retour


Journée 19

[Ven 19. Déc]
  20h30  RC Lens  2-0  OGC Nice
[Sam 20. Déc]
  17h00  Paris SG    0-0  Montpellier Hérault SC
  20h00  SM Caen     1-1  SC Bastia
         FC Lorient  1-2  FC Nantes
         FC Metz     0-1  AS Monaco FC
         Stade Rennais FC  1-3  Stade de Reims
         Toulouse FC  1-1  EA Guingamp
[Dim 21. Déc]
  14h00  Olympique de Marseille  2-1  LOSC Lille
  17h00  AS Saint-Étienne  3-0  Évian TG
  21h00  Girondins de Bordeaux  0-5  Olympique Lyonnais

Journée 20

[Ven 9. Janv]
  20h30  Montpellier Hérault SC 2-1 Olympique de Marseille
[Sam 10. Janv]
  17h00  SC Bastia 4-2 Paris SG
  20h00  Évian TG 1-1 Stade Rennais FC
  20h00  EA Guingamp 2-0 RC Lens
  20h00  LOSC Lille 1-0 SM Caen
  20h00  OGC Nice 3-1 FC Lorient
  20h00  Stade de Reims 1-2 AS Saint-Étienne
[Dim 11. Janv]
  17h00  Olympique Lyonnais 3-0 Toulouse FC
  17h00  FC Nantes 0-0 FC Metz
  21h00  AS Monaco FC 0-0 Girondins de Bordeaux

Journée 21

[Ven 16. Janv]
  20h30  Girondins de Bordeaux 1-2 OGC Nice
[Sam 17. Janv]
  17h00  RC Lens 0-2 Olympique Lyonnais
  20h00  SM Caen 4-1 Stade de Reims
  20h00  FC Lorient 1-0 LOSC Lille
  20h00  FC Metz 2-3 Montpellier Hérault SC
  20h00  AS Monaco FC 1-0 FC Nantes
  20h00  Toulouse FC 1-1 SC Bastia
[Dim 18. Janv]
  14h00  Paris SG 4-2 Évian TG
  17h00  Stade Rennais FC 0-0 AS Saint-Étienne
  21h00  Olympique de Marseille 2-1 EA Guingamp

Journée 22

[Ven 23. Janv]
  20h30  OGC Nice 2-1 Olympique de Marseille
[Sam 24. Janv]
  17h00  LOSC Lille 0-1 AS Monaco FC
  20h00  SC Bastia 0-0 Girondins de Bordeaux
  20h00  EA Guingamp 3-2 FC Lorient
  20h00  Montpellier Hérault SC 4-0 FC Nantes
[Dim 25. Janv]
  14h00  Évian TG 1-0 Toulouse FC
  14h00  Olympique Lyonnais 2-0 FC Metz
  17h00  Stade de Reims 0-0 RC Lens
  17h00  Stade Rennais FC 1-4 SM Caen
  21h00  AS Saint-Étienne 0-1 Paris SG

Journée 23

[Ven 30. Janv]
  20h30  Paris SG 1-0 Stade Rennais FC
[Sam 31. Janv]
  16h30  Olympique de Marseille 1-0 Évian TG
  20h00  RC Lens 1-1 SC Bastia
  20h00  FC Lorient 0-0 Montpellier Hérault SC
  20h00  FC Metz 0-0 OGC Nice
  20h00  FC Nantes 1-1 LOSC Lille
  20h00  Toulouse FC 1-0 Stade de Reims
[Dim 1. Févr]
  14h00  SM Caen 1-0 AS Saint-Étienne
  17h00  Girondins de Bordeaux 1-1 EA Guingamp
  21h00  AS Monaco FC 0-0 Olympique Lyonnais

Journée 24

[Ven 6. Févr]
  20h30  AS Saint-Étienne 3-3 RC Lens
[Sam 7. Févr]
  16h00  Stade Rennais FC 1-1 Olympique de Marseille
  20h00  SC Bastia 2-0 FC Metz
  20h00  SM Caen 2-0 Toulouse FC
  20h00  Évian TG 0-1 Girondins de Bordeaux
  20h00  Montpellier Hérault SC 1-2 LOSC Lille
  20h00  Stade de Reims 1-3 FC Lorient
[Dim 8. Févr]
  14h00  EA Guingamp 1-0 AS Monaco FC
  17h00  OGC Nice 0-0 FC Nantes
  21h00  Olympique Lyonnais 1-1 Paris SG

Journée 25

[Ven 13. Févr]
  20h30  Olympique de Marseille 2-2 Stade de Reims
[Sam 14. Févr]
  16h00  Paris SG 2-2 SM Caen
  20h00  RC Lens 0-2 Évian TG
  20h00  LOSC Lille 0-0 OGC Nice
  20h00  AS Monaco FC - Montpellier Hérault SC
  20h00  FC Nantes 0-2 SC Bastia
  20h00  Toulouse FC 2-1 Stade Rennais FC
[Dim 15. Févr]
  14h00  Girondins de Bordeaux 1-0 AS Saint-Étienne
  17h00  FC Metz 0-2 EA Guingamp
  21h00  FC Lorient 1-1 Olympique Lyonnais

Journée 26

[Ven 20. Févr]
  20h30  OGC Nice 0-1 AS Monaco FC
[Sam 21. Févr]
  17h00  Paris SG 3-1 Toulouse FC
  20h00  SC Bastia 2-1 LOSC Lille
  20h00  SM Caen 4-1 RC Lens
  20h00  Stade Rennais FC 1-1 Girondins de Bordeaux
[Dim 22. Févr]
  14h00  EA Guingamp 0-2 Montpellier Hérault SC
  17h00  Olympique Lyonnais 1-0 FC Nantes
  17h00  Stade de Reims 0-0 FC Metz
  21h00  AS Saint-Étienne 2-2 Olympique de Marseille
[Mer 4. Mars]
  19h00  Évian TG 1-0 FC Lorient

Journée 27

[Ven 27. Févr]
  20h30  Olympique de Marseille 2-3 SM Caen
[Sam 28. Févr]
  16h00  LOSC Lille 2-1 Olympique Lyonnais
  20h00  Girondins de Bordeaux 1-1 Stade de Reims
  20h00  RC Lens 0-1 Stade Rennais FC
  20h00  FC Lorient 2-0 SC Bastia
  20h00  FC Metz 1-2 Évian TG
  20h00  Toulouse FC 1-1 AS Saint-Étienne
[Dim 1. Mars]
  14h00  FC Nantes 1-0 EA Guingamp
  17h00  Montpellier Hérault SC 2-1 OGC Nice
  21h00  AS Monaco FC 0-0 Paris SG

Journée 28

[Ven 6. Mars]
  20h30  Toulouse FC 1-6 Olympique de Marseille
[Sam 7. Mars]
  17h00  Paris SG 4-1 RC Lens
  20h00  SC Bastia 2-1 OGC Nice
  20h00  SM Caen 1-2 Girondins de Bordeaux
  20h00  Évian TG 1-3 AS Monaco FC
  20h00  Stade de Reims 3-1 FC Nantes
  20h00  Stade Rennais FC 1-0 FC Metz
[Dim 8. Mars]
  14h00  AS Saint-Étienne 2-0 FC Lorient
  17h00  EA Guingamp 0-1 LOSC Lille
  21h00  Montpellier Hérault SC 1-5 Olympique Lyonnais

Journée 29

[Ven 13. Mars]
  20h30  AS Monaco FC 3-0 SC Bastia
  20h30  OGC Nice 1-2 EA Guingamp
[Sam 14. Mars]
  17h00  FC Metz 2-3 AS Saint-Étienne
  20h00  RC Lens 1-0 Toulouse FC
  20h00  FC Lorient 2-1 SM Caen
  20h00  Montpellier Hérault SC 3-1 Stade de Reims
  20h00  FC Nantes 2-1 Évian TG
[Dim 15. Mars]
  14h00  LOSC Lille 3-0 Stade Rennais FC
  17h00  Girondins de Bordeaux 3-2 Paris SG
  21h00  Olympique de Marseille 0-0 Olympique Lyonnais

Journée 30

[Ven 20. Mars]
  20h30  Paris SG - FC Lorient
[Sam 21. Mars]
  16h00  Olympique Lyonnais - OGC Nice
  20h00  SC Bastia - EA Guingamp
  20h00  SM Caen - FC Metz
  20h00  Évian TG - Montpellier Hérault SC
  20h00  Stade Rennais FC - FC Nantes
  20h00  Toulouse FC - Girondins de Bordeaux
[Dim 22. Mars]
  14h00  AS Saint-Étienne - LOSC Lille
  17h00  Stade de Reims - AS Monaco FC
  21h00  RC Lens - Olympique de Marseille

Journée 31

[Sam 4. Avril]
  20h00  Girondins de Bordeaux - RC Lens
  20h00  EA Guingamp - Olympique Lyonnais
  20h00  LOSC Lille - Stade de Reims
  20h00  FC Lorient - Stade Rennais FC
  20h00  Olympique de Marseille - Paris SG
  20h00  FC Metz - Toulouse FC
  20h00  AS Monaco FC - AS Saint-Étienne
  20h00  Montpellier Hérault SC - SC Bastia
  20h00  FC Nantes - SM Caen
  20h00  OGC Nice - Évian TG

Journée 32

[Dim 12. Avril]
  20h00  Girondins de Bordeaux - Olympique de Marseille
  20h00  SM Caen - AS Monaco FC
  20h00  Évian TG - LOSC Lille
  20h00  RC Lens - FC Lorient
  20h00  Olympique Lyonnais - SC Bastia
  20h00  Paris SG - FC Metz
  20h00  Stade de Reims - OGC Nice
  20h00  Stade Rennais FC - EA Guingamp
  20h00  AS Saint-Étienne - FC Nantes
  20h00  Toulouse FC - Montpellier Hérault SC

Journée 33

[Sam 18. Avril]
  20h00  SC Bastia - Stade de Reims
  20h00  EA Guingamp - Évian TG
  20h00  LOSC Lille - Girondins de Bordeaux
  20h00  FC Lorient - Toulouse FC
  20h00  Olympique Lyonnais - AS Saint-Étienne
  20h00  FC Metz - RC Lens
  20h00  AS Monaco FC - Stade Rennais FC
  20h00  Montpellier Hérault SC - SM Caen
  20h00  FC Nantes - Olympique de Marseille
  20h00  OGC Nice - Paris SG

Journée 34

[Sam 25. Avril]
  20h00  Girondins de Bordeaux - FC Metz
  20h00  SM Caen - EA Guingamp
  20h00  Évian TG - SC Bastia
  20h00  RC Lens - AS Monaco FC
  20h00  Olympique de Marseille - FC Lorient
  20h00  Paris SG - LOSC Lille
  20h00  Stade de Reims - Olympique Lyonnais
  20h00  Stade Rennais FC - OGC Nice
  20h00  AS Saint-Étienne - Montpellier Hérault SC
  20h00  Toulouse FC - FC Nantes

Journée 35

[Sam 2. Mai]
  20h00  SC Bastia - AS Saint-Étienne
  20h00  EA Guingamp - Stade de Reims
  20h00  LOSC Lille - RC Lens
  20h00  FC Lorient - Girondins de Bordeaux
  20h00  Olympique Lyonnais - Évian TG
  20h00  FC Metz - Olympique de Marseille
  20h00  AS Monaco FC - Toulouse FC
  20h00  Montpellier Hérault SC - Stade Rennais FC
  20h00  FC Nantes - Paris SG
  20h00  OGC Nice - SM Caen

Journée 36

[Sam 9. Mai]
  20h00  Girondins de Bordeaux - FC Nantes
  20h00  SM Caen - Olympique Lyonnais
  20h00  Évian TG - Stade de Reims
  20h00  RC Lens - Montpellier Hérault SC
  20h00  Olympique de Marseille - AS Monaco FC
  20h00  FC Metz - FC Lorient
  20h00  Paris SG - EA Guingamp
  20h00  Stade Rennais FC - SC Bastia
  20h00  AS Saint-Étienne - OGC Nice
  20h00  Toulouse FC - LOSC Lille

Journée 37

[Sam 16. Mai]
  20h00  SC Bastia - SM Caen
  20h00  Évian TG - AS Saint-Étienne
  20h00  EA Guingamp - Toulouse FC
  20h00  LOSC Lille - Olympique de Marseille
  20h00  Olympique Lyonnais - Girondins de Bordeaux
  20h00  AS Monaco FC - FC Metz
  20h00  Montpellier Hérault SC - Paris SG
  20h00  FC Nantes - FC Lorient
  20h00  OGC Nice - RC Lens
  20h00  Stade de Reims - Stade Rennais FC

Journée 38

[Sam 23. Mai]
  20h00  Girondins de Bordeaux - Montpellier Hérault SC
  20h00  SM Caen - Évian TG
  20h00  RC Lens - FC Nantes
  20h00  FC Lorient - AS Monaco FC
  20h00  Olympique de Marseille - SC Bastia
  20h00  FC Metz - LOSC Lille
  20h00  Paris SG - Stade de Reims
  20h00  Stade Rennais FC - Olympique Lyonnais
  20h00  AS Saint-Étienne - EA Guingamp
  20h00  Toulouse FC - OGC Nice
TXT

    filler = SportDb::AutoFiller.new( txt_i )
    txtup, changelog = filler.autofill

    pp changelog

    assert_equal txtup, txt_i
  end
end # class TestAutoFill
