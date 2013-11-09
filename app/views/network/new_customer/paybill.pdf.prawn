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

def left_side(pdf,w,d)
  def payer_table(pdf,w,d)
    w1 = 130
    pdf.make_table [['გადამხდელის დასახელება', d[:payer], '']] do |t|
      t.column_widths = [w1, w - w1 - 5, 5]
      t.cells.style borders: []
      t.row(0).column(1).style borders: [:bottom]
    end
  end
  def payer_bankaccount_table(pdf,w,d)
    w1 = 130
    pdf.make_table [['ანგარიში (დებეტი)', d[:payer_account], '']] do |t|
      t.column_widths = [w1, w - w1 - 5, 5]
      t.cells.style borders: []
      t.row(0).column(1).style borders: [:bottom, :top, :left, :right], align: :center
    end
  end
  def payer_bank_table(pdf,w,d)
    w1 = 96
    w2 = 160
    w3 = 63
    pdf.make_table [['გადამხდელის ბანკი', d[:payer_bank], 'ბანკის კოდი', d[:payer_bank_code], '']] do |t|
      t.column_widths = [w1, w2, w3, w - w1 - w2 - w3 - 5, 5 ]
      t.cells.style borders: []
      t.row(0).column(1).style borders: [:bottom], align: :center
      t.row(0).column(3).style borders: [:bottom], align: :center
    end
  end
  def govpayer_name(pdf,w,d)
    w1 = 150
    pdf.make_table [['გადასახადის გადამხდელის დასახელება', '', '']] do |t|
      t.column_widths = [w1, w - w1 - 5, 5]
      t.cells.style borders: [:top]
      t.row(0).column(1).style borders: [:bottom, :top]
    end
  end
  def govpayer_params(pdf,w,d)
    w1 = 140
    w2 = 50
    w3 = 130
    pdf.make_table [['გადასახადის გადამხდელის საიდენტიფიკაციო ნომერი', '', 'ბიუჯეტის შემოსულობების სახაზინო კოდი', '', '']] do |t|
      t.column_widths = [w1, w2, w3, w - w1 - w2 - w3 - 5, 5 ]
      t.cells.style borders: []
      t.row(0).column(1).style borders: [:bottom], align: :center
      t.row(0).column(3).style borders: [:bottom], align: :center
    end
  end
  def receiver_table(pdf,w,d)
    w1 = 130
    pdf.make_table [['მიმღების დასახელება', d[:receiver], '']] do |t|
      t.column_widths = [w1, w - w1 - 5, 5]
      t.cells.style borders: [:top]
      t.row(0).column(1).style borders: [:bottom, :top]
    end
  end
  def receiver_bankaccount_table(pdf,w,d)
    w1 = 130
    pdf.make_table [['ანგარიში (კრედიტი)', d[:receiver_account], '']] do |t|
      t.column_widths = [w1, w - w1 - 5, 5]
      t.cells.style borders: []
      t.row(0).column(1).style borders: [:bottom, :top, :left, :right], align: :center
    end
  end
  def receiver_bank_table(pdf,w,d)
    w1 = 96
    w2 = 160
    w3 = 63
    pdf.make_table [['მიმღების ბანკი', d[:receiver_bank], 'ბანკის კოდი', d[:receiver_bank_code], '']] do |t|
      t.column_widths = [w1, w2, w3, w - w1 - w2 - w3 - 5, 5 ]
      t.cells.style borders: []
      t.row(0).column(1).style borders: [:bottom], align: :center
      t.row(0).column(3).style borders: [:bottom], align: :center
    end
  end
  def reason_table(pdf,w,d)
    w1 = 130
    pdf.make_table [['გადახდის დანიშნულება:', d[:reason], '']] do |t|
      t.column_widths = [w1, w - w1 - 5, 5]
      t.cells.style borders: [:top]
      t.row(0).column(1).style borders: [:bottom, :top]
    end
  end
  def additiona_info_table(pdf,w,d)
    w1 = 130
    pdf.make_table [['დამატებითი ინფორმაცია:', '', ''], [' ', '', ''], [' ', '', '']] do |t|
      t.column_widths = [w1, w - w1 - 5, 5]
      t.column(0).style borders: []
      t.column(2).style borders: []
      t.row(0).style borders: [:top]
      t.column(1).style borders: [:bottom]
      t.row(0).column(1).style borders: [:top, :bottom]
    end
  end
  default_font(pdf)
  data = [
    [ "#{d[:date].strftime('%Y')} წლის #{d[:date].strftime('%d')} #{month_name(d[:date].month)}"],
    [ payer_table(pdf,w,d) ],
    [ payer_bankaccount_table(pdf,w,d) ],
    [ payer_bank_table(pdf,w,d) ],
    [ govpayer_name(pdf,w,d) ],
    [ govpayer_params(pdf,w,d) ],
    [ receiver_table(pdf,w,d) ],
    [ receiver_bankaccount_table(pdf,w,d) ],
    [ receiver_bank_table(pdf,w,d) ],
    [ reason_table(pdf,w,d) ],
    [ additiona_info_table(pdf,w,d) ],
  ]
  pdf.make_table data do |t|
    t.column_widths = [ w ]
    t.row(0).column(0).style align: :center
    t.cells.style borders: [], padding: [ 5, 0 ]
  end
end

def right_side(pdf,w,d)
  def amount_table(pdf,w,d)
    amount_i = d[:amount].to_i
    amount_t = ((d[:amount] - amount_i) * 100).round
    data = [['', 'თანხა', ''], ['', "#{d[:amount]} GEL", ''], ['', 'თანხა სიტყვებით', ''], ['', "#{amount_i.to_ka} ლარი #{amount_t} თეთრი", ''],
      ['', '', ''], ['', 'ბანკის აღნიშვნები', ''], ['', 'ბანკში შემოსვლის თარიღი:'], ['', ' ', ''],
      ['', 'გატარებულია ბანკის მიერ:', ''], ['', ' ', ''],
      ['', 'ხელმოწერა:', ''], ['', ' ', ''], ['', ' ', ''],
      ['', 'შტამპის ადგილი', ''],
    ]
    pdf.make_table data do |t|
      t.column_widths = [5,w-10,5]
      t.cells.style borders: [], align: :center
      t.row(0).style size: 15, padding: [15,0]
      t.row(1).column(1).style borders: [:top, :right, :bottom, :left]
      t.row(3).column(1).style borders: [:bottom]
      t.row(4).style borders: [:bottom]
      t.row(5).style size: 15, padding: [15, 0]
      t.row(7).column(1).style borders: [:bottom]
      t.row(9).column(1).style borders: [:bottom]
      t.row(11).column(1).style borders: [:bottom]
      t.row(13).column(1).style borders: [:top, :right, :bottom, :left], padding: [10,0]
    end
  end
  default_font(pdf)
  pdf.make_table([[amount_table(pdf, w, d)]]) do |t|
    t.column_widths = [ w ]
    t.cells.style borders: []
  end
end

prawn_document(page_size: 'A4', margin: [30, 20]) do |pdf|
  pdf.pad_bottom(10) do
    pdf.change_font('serif-bold')
    pdf.text "საგადახდო დავალება № __________", align: :center, size: 12
  end
  width = pdf.bounds.width
  width_left = width * 0.7
  width_right = width - width_left
  data = [[ left_side(pdf, width_left, @data), right_side(pdf, width_right, @data) ]]
  pdf.table data do |t|
    t.column_widths = [ width_left, width_right ]
  end
  pdf.text ' '
  pdf.table [['ხელმოწერა', 'ბ.ა.']] do |t|
    t.column_widths = [200, nil]
    t.column(0).style borders: []
    t.column(1).style padding: 20
  end
end
