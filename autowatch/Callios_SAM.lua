return {
    ["slave"]=false, 
    ["master"]=true, 
    ["target"]="Morta", 
    ["cells"]=false, 
    ["actions"]={
        [1]={
            ["prefix"]="/jobability", 
            ["action"]="Hasso", 
            ["condition"]="ready", 
            ["modifier"]=""
        }, 
        [2]={
            ["prefix"]="/weaponskill", 
            ["action"]="Tachi: Fudo", 
            ["condition"]="tp", 
            ["modifier"]="1250"
        }, 
        [3]={
            ["prefix"]="/jobability", 
            ["action"]="Meditate", 
            ["condition"]="ready", 
            ["modifier"]=""
        }, 
        [4]={
            ["action"]="Impulse Drive", 
            ["prefix"]="/weaponskill", 
            ["condition"]="tp", 
            ["modifier"]="2000"
        }
    }, 
    ["should_engage"]=true, 
    ["rubicund"]=0, 
    ["leech"]=false, 
    ["displacer"]=0, 
    ["trusts"]={}
}