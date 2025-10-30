require 'asciidoctor'
require 'asciidoctor/extensions'

Asciidoctor::Extensions.register do
  block do
    named :blocks_to_table
    on_context :example
    process do |parent, reader, attrs|
      content = reader.read
      # Split into sub-blocks starting with `.Title`
      blocks = content.split(/^\.(?=[^\n]+)/).reject(&:empty?)

      table_lines = []
      table_lines << '[cols="a",options="header"]'
      table_lines << '|==='
      table_lines << '| Title | Content'

      blocks.each do |b|
        lines = b.strip.lines
        title = lines.shift.strip
        title.sub!(/^\./, '') # remove leading dot
        table_lines << "| #{title} |"
        table_lines << lines.join.strip
      end

      table_lines << '|==='

      # Reparse the table as AsciiDoc content
      create_block parent, :open, table_lines.join("\n"), attrs, subs: nil
    end
  end
end
