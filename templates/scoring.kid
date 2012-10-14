<?python
layout_params['page_title'] = "Mayweek 2008 Scoring System"
?>
<html py:layout="'base_layout.kid'" xmlns:py="http://purl.org/kid/ns#">
<div py:match='item.tag == "content"'>
   <h3>Basic Details</h3>
    <p>The main scoring algorithm for this game is an implementation of <a href="http://math.bu.edu/people/mg/glicko/glicko2.doc/example.html">Glicko-2</a>, a statistical system based on the Elo ranking system used in tournament chess. This attempts to estimate a players &quot;true strength&quot; from their performance, using statistical methods. The algorithm calculates your average expected strength and the uncertainty in it. The score that is then reported is the lower bound of a confidence interval; the lowest strength you could reasonably have without being inconsistent with the data.</p>
    <p>The more unexpected the result of an encounter is, the more your score will change. Killing someone who is far beneath you will gain you very few points, because you would be expected to win that encounter. Killing someone far above you will gain you a lot of points, even if they kill you at the same time. </p>
    <p>If you are unlucky enough to shoot an innocent (who is not a legal target), you will lose points. You will lose 35 points each for the first two innocents, 70 for the next one, 140 for the next one, etc. If more innocents that that matter to you, the Umpire may begin to become anxious.</p>
    <h3>Executive summary for non-mathematicians:</h3>
     <ol><!--ololol-->
      <li>You get points for killing people</li>
      <li>You get more points for killing good people</li>
      <li>You get few points from killing people who are more than about 700 points below you</li>
      <li>You lose points for dying, but you also gain points for interacting. Sometimes you gain more points than you lose.</li>
      <li>You lose less points for dying to someone who is ranked highly above you.</li>
      <!--ontol--></ol><!--ogy-->
      <h3>Details for the mathematically inclined</h3>
      <p>In addition, any encounter will decrease the uncertainty associated with your score, thus increasing the lower bound of your confidence interval and hence increasing your score. This means that for your first few encounters you will generally gain points, <b>even if you die</b>. This especially holds true if your first interaction is to be shot by the game leader on day 4; you would lose very few points from your expected strength, because it predicted you would lose and you did, but you would vastly decrease the uncertainty. The total effect would be to gain you points.</p>
    <p>The game leaders usually have enough encounters that their uncertainty will not decrease greatly from a few more. Thus, they get points only for good kills, not for interaction.</p>
    <p>There is a very small decay on the uncertainty; typically this means that if you do nothing all week, you will lose about 1% of your initial points. This is not expected to be important.</p>
    <p>Experienced scoring aficionados will notice that Glicko has the concept of a rating period, and is thus time-dependent. Even more experienced scorers will notice that reporting the score as the lower bound of a confidence interval means that our scoring system is not zero-sum.</p>
    <p>You start with an expected score of 1500, and an uncertainty of 350. This means that your initial score will be 1500-350=1150.</p>
    <p>The parameters of Glicko are: 
    <ul style="list-style-type:circle">
          <li>initial volatility: 0.06 (this makes little difference)</li>
          <li>tau: 1 (this makes no difference)</li>
          <li>rating period: 4 hours</li>
          <li>Reported score: mean - RD. The lower edge of a 68% confidence interval.</li>
    </ul>
    </p>
      <h3>Style Points</h3>
    <p>In addition, there will be &quot;style points&quot;. These will be awarded entirely at umpirical discretion, for any action I consider particularly stylish. They will not carry Glicko points. Examples of stylish acts include making kills by walking to Girton (unless you live there), making a kill with a knife, making kills while wearing a silly hat, making a kill after claiming to be Tom Baker, or anything involving Extreme Ironing.</p>

</div>
</html>
