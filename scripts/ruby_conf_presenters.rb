require "./models/item"

names = ["Yukihiro Matsumoto", "Saron Yitbarek", "Bianca Escalante", "Jessie Shternshus", "Adam Forsyth", "Alex Peattie", "Allison McMillan", "Andrew Louis", "Andy Croll", "Andy Glass", "Beth Haubert", "Brad Urani", "Brandon Weaver", "Cameron Dutro", "Chris Salzberg", "Cody Stringham", "Damir Svrtan", "Greggory Rothmeier", "Jeffrey Cohen", "Jeremy Evans", "Jonan Scheffler", "Katherine Wu", "Kevin Kuchta", "Koichi Sasada", "Mark Siemers", "Masayoshi Takahashi", "Yurie Yamane", "Nadia Odunayo",
         "Noel Rappin", "Pranav Garg", "Ryan Davis", "Sumana Harihareswara", "Jason Owen", "Takashi Kokubun", "Tekin Suleyman", "Thomas E Enebo", "Charles Oliver Nutter", "Tony Drake", "Vladimir Dementyev", "Audrey Eschright", "Caleb Thompson", "Cecy Correa", "Colin Fleming", "Eric Weinstein", "Cory Chamblin", "Courtney Eckhardt", "Kelsey Pedersen", "Aaron Patterson", "Colin Fulton", "Michael Herold", "Brandon Hays", "Jennifer Tu", "Jim Liu", "Nickolas Means", "Anna Gluszak", "Jamie Gaskins",
         "Molly Struve", "ITOYANAGI Sakura", "Tomohiro Hashidate", "Satoshi Tagomori", "Yoh Osaki", "Aaron Harpole", "Annie Sexton", "Jack Danger", "Mercedes Bernard", "Daniel Azuma", "James Thompson", "Jeremy Hanna"]

names.each do |name|
  Item.new(template: :laptop_sleeve,
           font: Item::AVAILABLE_FONTS.sample,
           text: name,
           file_name: name.gsub(" ", ""))
end
