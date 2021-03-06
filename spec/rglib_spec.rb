require 'spec_helper'

module Rglib
  describe "Library" do
    it "has a version number" do
      expect(VERSION).not_to be nil
    end

    before(:all) do
      @lib =  Library.new
      @lib << Author.new("Mark Twain", "biography")
      @lib << Author.new("F. Scott Fitzgerald", "biography")
      @lib << Author.new("George R. R. Martin", "biography")
      @lib << Book.new("The Adventures of Tom Sawyer", @lib.authors[0])
      @lib << Book.new("The Great Gatsby", @lib.authors[1])
      @lib << Book.new("A Game of Thrones", @lib.authors[2])
      @lib << Reader.new("Jon Snow", { email: "jon.snow@bastards.org", city: "Winterfell" })
      @lib << Reader.new("Tyrion Lannister", { email: "tyrion@halfman.org",  city: "Casterly Rock" })
      @lib << Reader.new("Arya Stark", { email: "arya@stark.org", city: "Winterfell" })
      @lib << Order.new(@lib.books[0], @lib.readers[2])
      @lib << Order.new(@lib.books[0], @lib.readers[2])
      @lib << Order.new(@lib.books[0], @lib.readers[1])
      @lib << Order.new(@lib.books[0], @lib.readers[0])
      @lib << Order.new(@lib.books[1], @lib.readers[1])
      @lib << Order.new(@lib.books[2], @lib.readers[0])
    end

    subject(:author) { @lib.authors.first }
    subject(:book)   { @lib.books.first }
    subject(:reader) { @lib.readers.last }
    subject(:order)  { @lib.orders.first }

    describe Author do
      it "should respond to 'name'" do
        expect(author.name).to eq("Mark Twain")
      end

      it "should respond to 'biography'" do
        expect(author.biography).to eq("biography")
      end

      it "should respond to 'to_s'" do
        expect(author.to_s).to eq("Mark Twain. biography")
      end
    end

    describe Book do
      it "should respond to 'title'" do
        expect(book.title).to eq("The Adventures of Tom Sawyer")
      end

      it "should respond to 'author'" do
        expect(book.author).to eq(author)
      end

      it "should respond to 'to_s'" do
        expect(book.to_s).to eq("\"The Adventures of Tom Sawyer\" by Mark Twain")
      end
    end

    describe Order do
      it "should respond to 'book'" do
        expect(order.book).to eq(book)
      end

      it "should respond to 'reader'" do
        expect(order.reader).to eq(reader)
      end

      it "should respond to 'date'" do
        expect(order.date).to eq(Time.now.strftime("%Y-%m-%d at %H:%M"))
      end

      it "should respond to 'to_s'" do
        expect(order.to_s).to eq("\"The Adventures of Tom Sawyer\" ordered by Arya Stark. Date: #{order.date}.")
      end
    end

    describe Reader do
      it "should respond to 'name'" do
        expect(reader.name).to eq("Arya Stark")
      end

      it "should respond to 'to_s'" do
        expect(reader.to_s).to eq("Arya Stark from Winterfell <arya@stark.org>")
      end
    end

    describe Library do
      it "can shows who often takes the book" do
        expect(@lib.who_often_takes_the_book(book)).to eq([reader, 2])
      end

      it "can shows the most popular book" do
        expect(@lib.most_popular_book).to eq(book)
      end

      it "can shows how many people ordered one of the three most popular books" do
        expect(@lib.how_many_people_ordered_one_of_the_three_most_popular_books).to match_array([[book, 4], [@lib.books[1], 1], [@lib.books[2], 1]])
      end
      
      describe "Can works with a file database" do
        after(:all) { File.delete('library.db') }

        it "creates the 'library.db' file" do
          @lib.save
          expect(File.exists?('library.db')).to be(true)
        end

        it "loads from the 'library.db' file" do
          @newlib = Library.load
          expect(@newlib).not_to be_nil
        end
      end
    end
  end
end
