AD = {}

ESX = exports["es_extended"]:getSharedObject()


AD.Target = "qtarget"
AD.ProgressBar = "ad-progressbar"
AD.CrackIcon = "fas fa-recycle"
-- REWARD OPTIONS
AD.NormalCash = false -- if false it will use black money
AD.Cash = math.random(5000, 10000)
AD.NormalCashName = 'money' -- change this if using custom name
AD.BlackMoneyName = 'black_money'

-- TIMES
AD.BrokeTime = math.random(25000, 45000)
AD.ProgressTime = 7000
AD.TextLength = 2000 -- 3d text leight

-- LOCALES
AD.TextCrack = "Casser le guichet automatique"
AD.TextPutToCar = "Remonter dans la voiture"
AD.TextAttach = "Connecter la corde au guichet automatique"
AD.TextTCrack = "Casser le guichet automatique"
AD.Text = "Appuyez sur E pour joindre un guichet automatique | Appuyez sur X pour retirer la corde"
AD.TextGotCash = "tu as"

-- ROPE ITEM
AD.RopeItemName = "rope"
AD.RopeItemCount = 1 -- how many ropes will be removed
AD.UseRopeNotify = "tu as utilisé de la corde"
AD.DontHaveRope = "Tu n'as pas de corde"