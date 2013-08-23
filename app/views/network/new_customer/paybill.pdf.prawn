def make_paybill_table(app)
  # make_table
end

prawn_document(page_size: 'A4', margin: [30, 20]) do |pdf|
  pdf.pad_bottom(10) do
    pdf.change_font('serif-bold')
    pdf.text "საგადახდო დავალება № #{@data[:number]}", align: :center, size: 12
  end
  pdf.change_font
  pdf.table([['1', '2']], column_widths: [300,100])
end