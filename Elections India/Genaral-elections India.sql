-- Party with highest no.of seats
select party,count(*) as seats_won
from partywise_results
group by Party
order by seats_won desc
limit 1;
-- wining margin analysis
with rankedmargin as
(
select constituencyName, WinningCandidate, Margin,
Row_Number() Over (order by Margin DESC ) as HighestRank,
Row_Number() Over (order by Margin ASC ) as LowestRank from constituencywise_results)
select constituencyName,WinningCandidate,Margin
From RankedMArgins Where HighestRank = 1 or LowestRAnk=1;

-- Total votes by party
select P.Party,sum(c.Totalvotes) as totalvotes
from constituencywise_results c
join partywise_results P on c.PartyID = P.PartyID
group by P.Party;
-- Closest contest analysis
select ConstituencyName,Margin
from constituencywise_results
order by Margin Asc
limit 1;
-- Statewise Turnover
select sr.State,cr.TotalVotes as totalvotescaste
from constituencywise_results cr
join statewise_result sr on cr.ConstituencyName =sr.Constituency
group by sr.State,TotalVotescast
order by TotalVotescast asc
limit 1;
-- winning analysis
select ConstituencyName,(WinningCandidate/TotalVotes)*100 as percentage_votes_secured
from constituencywise_results;
-- Majority constituencies
select count(*) as constituencies_Above_50_percent
from constituencywise_results
where (((TotalVotes + Margin)/2)*100.0/TotalVotes)>50;
-- Runnerup party analysis
select party,count(*) as runnerup_count
from
( select c.party,c.totalvotes
from candidates c
where 2 =(
select count(*)
from candidates
where c2.ConstituencyID=c.constituency_id and c2.TotalVotes >= c.totalvotes)) As t
group by party
order by runnerup_count
limit 1;
-- Independent Candidate's Performance
select ConstituencyId,count(*) as winning_Independent_candidates
from candidates c
where 'Independent' And c.TotalVotes In (
Select max(totalvotes)
from Constituencywise_Results
Group by constituencyID)
Group by constitiuencyID;
-- Victory Margin Trends :
select Avg(maxvotes-runnerupvotes) as avgvictorymargin
from(
select 
c.constituencyid,
-- Top vote getter(winner)
(Select totalvotes
from candidadtes c1
where c1.constituencyid =c.constituencyid
order by totalvotes desc
limit 1 offset 0 ) as maxvotes,
(select totalvotes
from candidates c2
where c2.consitunencyId=c.constituencyid
order by totalvotes desc
limit 1
offset 1) as runnerupvotes
from candidates c
group by c.constituencyid
) as votemargins;



