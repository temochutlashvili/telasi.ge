def default_font(pdf, size = 9); pdf.change_font('default', size) end

def month_name(month)
  case month
  when 1 then 'იანვარი'
  when 2 then 'თებერვალი'
  when 3 then 'მარტი'
  when 4 then 'აპრილი'
  when 5 then 'მაისი'
  when 6 then 'ივნისი'
  when 7 then 'ივლისი'
  when 8 then 'აგვისტო'
  when 9 then 'სექტემბერი'
  when 10 then 'ოქტომბერი'
  when 11 then 'ნოემბერი'
  when 12 then 'დეკემბერი'
  end
end

def page1(pdf)
  default_font(pdf, 8)
  pdf.text %Q{"დამტკიცებულია"\n
    საქართველოს ენერგეტიკისა და წყალმომარაგების
    მარეგულირებელი ეროვნული კომისიის
    2011 წლის 22 ნოემბრის №30/1 გადაწყვეტილებით }, align: :right
  pdf.move_down 50
  pdf.text 'განცხადება', size: 20, align: :center
  pdf.text 'გამანაწილებელ ქსელზე ახალი მომხარებლის მიერთების მოთხოვნის შესახებ', align: :center, size: 10
  pdf.move_down 20
  default_font(pdf)
  date = @application.created_at
  pdf.table [['განაცხადის შევსების  თარიღი:', "#{date.day} #{month_name(date.month)} #{date.year}"]], column_widths: [nil, 150] do |t|
    t.column(0).style borders: []
    t.column(1).style borders: [:bottom], align: :center
  end
  pdf.move_down 30
  pdf.text 'I. ზოგადი ინფორმაცია ', size: 15, align: :center
  pdf.move_down 10
  pdf.table [['ელექტროენერგიის განაწილების ლიცენზიანტი:', 'სს თელასი'], ['მიერთების მსურველი (განმცხადებლი):', @application.rs_name]],
    column_widths: [220, 250] do |t|
    t.column(0).style borders: []
    t.column(1).style borders: [:bottom]
  end
  pdf.move_down 5
  pdf.text '(სახელი, გვარი ან იურიდიული პირის შემთხვევაში მისი სახელი (სახელწოდება), ან სხვა პირის შემთხვევაში მისი სახელწოდება)', size: 6, align: :center
  pdf.table [['საიდენტიფიკაციო კოდი:', @application.rs_tin]],
    column_widths: [220, 250] do |t|
    t.column(0).style borders: []
    t.column(1).style borders: [:bottom]
  end
  pdf.move_down 5
  pdf.text '(იურიდიული პირის ან ინდმეწარმის ან სხვა მეწარმე სუბიექტის შემთხვევაში)', size: 6, align: :center
  pdf.move_down 20
  pdf.text 'მიერთების მსურველის (განმცხადებლის) საკონტაქტო ინფორმაცია:'
  pdf.move_down 10
  pdf.table [['მისამართი:', @application.address]],
    column_widths: [70, 400] do |t|
    t.column(0).style borders: []
    t.column(1).style borders: [:bottom]
  end
  pdf.table [['მობილური:', @application.mobile, 'ელ.ფოსტა:', @application.email]],
    column_widths: [70,150,70,180] do |t|
    t.column(0..3).style borders: []
    t.column(1).style borders: [:bottom]
    t.column(3).style borders: [:bottom]
  end
  pdf.move_down 20
  pdf.text 'მიერთების მსურველის (განმცხადებლის) საბანკო რეკვიზიტები:'
  pdf.move_down 10
  pdf.table [['ბანკის კოდი და დასახელება:', "#{@application.bank_code}, #{@application.bank_name}"], ['ანგარიშის ნომერი:', @application.bank_account]],
    column_widths: [170,300] do |t|
    t.column(0..3).style borders: []
    t.column(1).style borders: [:bottom]
    t.column(3).style borders: [:bottom]
  end
  pdf.move_down 20
  pdf.text 'ადგილი (მისამართი) სადაც უნდა მოხდეს ელექტრომომარაგება:'
  pdf.move_down 10
  pdf.table [["#{@application.address_code}, #{@application.address}"]], column_widths: [470] do |t|
    t.column(0).style borders: [:bottom]
  end
  pdf.move_down 20
  pdf.text 'განაწილების ლიცენზიატის მიერ შეტყობინების გაგზავნის ფორმა:'
  pdf.move_down 10
  pdf.text "☐ წერილობითი\n ☒ ელექტრონული", size: 10
end

def page2(pdf)
  pdf.text 'II. ერთი ან ორი აბონენტის მიერთების მოთხოვნის შემთხვევაში ☒', size: 15, align: :center
  pdf.text '(ივსება მხოლოდ მიერთების შედეგად  ერთი ან ერთდროულად ორი აბონენტის რეგისტრაციის მოთხოვნის შემთხვევაში)', size: 8, align: :center
  pdf.move_down 20
  pdf.text 'განაცხადით მოთხოვნილი აბონენტთა რაოდენობა: ☒ ერთი; □ ორი.'
  pdf.move_down 20
  width = pdf.bounds.width / 2
  pdf.table [['-1-', '-2-'],
    ['1. დაზუსტებული მისამართი, სადაც უნდა მოხდეს ელექტრომომარაგება:'] * 2,
    [(@application.work_address || @application.address), ''],
    ['2.აბონენტის (მოხმარებული ელ. ენერგიის საფასურის გადახდაზე პასუხისმგებელი პირის) სახელი, გვარი ან იურიდიული პირის სახელი:'] * 2,
    [@application.rs_name, ''],
    ['2.1. პირადი ნომერი ან საიდენტიფიკაციო კოდი:'] * 2,
    [@application.rs_tin, ''],
    ['3. ელექტროენერგიის მოხმარების მიზანი:'] * 2,
    ['☒ საყოფაცხოვრებო, □ არასაყოფაცხოვრებო.', '□ საყოფაცხოვრებო, □ არასაყოფაცხოვრებო.'],
    ['4. უძრავი ქონების საკადასტრო კოდი (სადაც უნდა მოხდეს ელექტრომომარაგება):'] * 2,
    [@application.address_code, ''],
    ['5. მოთხოვნილი ძაბვის საფეხური:'] * 2,
    ["#{(@application.voltage == '220' ? '☒' : '□')} 220ვ;  #{(@application.voltage == '380' ? '☒' : '□')} 380ვ;  #{(@application.voltage == '6/10' ? '☒' : '□')} 6/10კვ", '□ 220ვ;  □ 380ვ;  □ 6/10კვ'],
    ['6. მოთხოვნილი სიმძლავრე:'] * 2,
    ["#{@application.power} კვტ", ''],
    ['7. გამანაწილებელ ქსელზე მიერთების საფასური (შეთავაზებული პაკეტის მიხედვით):'] * 2,
    ["#{@application.amount} GEL", ''],
  ], column_widths: [ width, width ] do |t|
    t.column(0).style borders: [:left, :right]
    t.column(1).style borders: [:right]
    t.row(0).style borders: [:left, :right, :top]
    t.row(2).style borders: [:left, :right, :bottom], align: :center, size: 10
    t.row(4).style borders: [:left, :right, :bottom], align: :center, size: 10
    t.row(6).style borders: [:left, :right, :bottom], align: :center, size: 10
    t.row(8).style borders: [:left, :right, :bottom], align: :center, size: 10
    t.row(10).style borders: [:left, :right, :bottom], align: :center, size: 10
    t.row(12).style borders: [:left, :right, :bottom], align: :center, size: 10
    t.row(14).style borders: [:left, :right, :bottom], align: :center, size: 10
    t.row(16).style borders: [:left, :right, :bottom], align: :center, size: 10
  end
  pdf.move_down 20
  pdf.text 'III. ერთდროულად სამი ან სამზე მეტი აბონენტის  მიერთების მოთხოვნის შემთხვევაში □', size: 15, align: :center
  pdf.move_down 10
  pdf.text 'განაცხადით მოთხოვნილი აბონენტთა (ინდ.აღრიცხვა) საერთო რაოდენობა: ___'
  pdf.move_down 10
  pdf.text 'საყოფაცხოვრებო და არასაყოფაცხოვრებო აბონენტთა რაოდენობა: საყოფაცხოვრებო ____ არა საყოფაცხოვრებო ___ განცალკევებული აღრიცხვა ___ (განათება, ლიფტი და სხვა მიზნებისთვის)'
  pdf.move_down 10
  pdf.text 'უძრავი ქონების საკადასტრო კოდი (სადაც უნდა მოხდეს ელექტრომომარაგება): __________________'
  pdf.move_down 10
  pdf.text 'საცხოვრებელი ბინის, საწარმოს ან სხვა სახის ობიექტის (ან ობიექტების) სამშენებლო-საპროექტო დოკუმენტაციით განსაზღვრული (დადგენილი) მისაერთებელი სიმძლავრე: ____'
  pdf.move_down 10
  pdf.text 'გამანაწილებელ ქსელზე მიერთების საფასური (შეთავაზებული პაკეტის მიხედვით): ______'
end

def page3(pdf)
  pdf.text 'IV. თანდართული დოკუმენტაცია:', size: 15, align: :center
  pdf.move_down 20
  pdf.text 'მიერთების საფასურის 50%-ის გადახდის დამადასტურებელი საბუთი ☒'
  pdf.move_down 10
  pdf.text 'ერთდროულად სამი ან სამზე მეტი აბონენტის რეგისტრაციის მოთხოვნის შემთხვევაში: □'
  pdf.move_down 10
  pdf.text 'საპროექტო ორგანიზაციის მიერ დამოწმებული, მისაერთებელი ობიექტის "პროექტის ელექტრულ ნაწილზე ახსნა–განმარტებითი ბარათი" (რომელიც დამუშავებულია, დამტკიცებული პროექტის არქიტექტურულ–სამშენებლო ნაწილის მონაცემების საფუძველზე) □'
  pdf.move_down 10
  pdf.text 'აბონენტების მიხედვით დაზუსტებული მისამართები მოთხოვნილი ძაბვის საფეხური და მოთხოვნილი სიმძლავრეები -- შევსებული დანართი 1.1 მიხედვით; □'

  pdf.move_down 40
  pdf.text 'V. განაცხადის პირობები', size: 15, align: :center
  pdf.move_down 20
  pdf.text '1.  ამ განაცხადის ხელმოწერით ვადასტურებ, რომ  განაწილების ლიცენზიატის მიერ ამ განაცხადის მიღებისა და მასში ასახული პირობების შესრულების შემთხვევაში, შევასრულებ საქართველოს ენერგეტიკისა და წყალმომარაგების მარეგულირებელი კომისიის მიერ დამტკიცებული „ელექტროენერგიის (სიმძლავრის) მიწოდებისა და მოხმარების წესებით“ განსაზღვრულ ვალდებულებებს, მათ შორის დროულად გადავიხდი გამანაწილებელ ქსელზე ახალი მომხმარებლის მიერთების დადგენილ საფასურს.'

  pdf.move_down 40
  pdf.table [['განმცხადებლის ხელმოწერა:', '']], column_widths: [150, 270] do |t|
    t.column(0).style borders: []
    t.column(1).style borders: [:bottom]
  end
end

prawn_document(page_size: 'A4', margin: [50, 40]) do |pdf|
  page1(pdf)
  pdf.start_new_page
  page2(pdf)
  pdf.start_new_page
  page3(pdf)
end
