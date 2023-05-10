echo 'you must be on the root where you want the feature other god help 
you'
echo '------------------------------'
mkdir $1  &&
cd $1    &&
mkdir data domain presentation &&
cd data && 
mkdir data_source models repository &&
cd .. && 
cd domain && 
mkdir entites repository  use_cases && 
cd .. && 
cd presentation && 
mkdir bloc screens widgets
echo '-------------------------------'
echo 'done'
echo pwd

