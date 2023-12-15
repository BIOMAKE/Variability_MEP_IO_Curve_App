function returnme = myreplace_naninf(inputvar)
%   ersetzt NaN und Inf gegen sqrt(realmax) oder dergleichen,
%   bei fit sollte Minimierer dann auch nicht dorthin konvergieren

returnme = inputvar;
returnme(not(isfinite(returnme))) = 1e90;   %sqrt(realmax);
