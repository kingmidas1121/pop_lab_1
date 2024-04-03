with Ada.Text_IO;

procedure Main is

   thread_count : constant Integer := 5;
   type Boolean_Array is array (Integer range <>) of Boolean;
   flags_for_threads : Boolean_Array(1..thread_count) := (others => False);
   type Int_Array is array (Integer range <>) of Integer;
   --time_to_stop : Int_Array(1..thread_count);
   ID : Int_Array(1..thread_count);
   time_to_stop : Int_Array(1..thread_count) := (3, 20, 7, 2, 14);

  task type break_thread is
      entry Start;
   end;
   task type main_thread is
      entry Start(id: in Integer; step: in Integer);
   end;

   break : break_thread;


   threads : array(1..thread_count) of main_thread;

   procedure Swap(Arr: in out Int_Array; Index1, Index2: Integer) is
      Swap_Temp: Integer;
   begin
      Swap_Temp := Arr(Index1);
      Arr(Index1) := Arr(Index2);
      Arr(Index2) := Swap_Temp;
   end Swap;

   procedure Sort is
      N : constant Integer := time_to_stop'Length;
      Swapped : Boolean := True;
   begin
      while Swapped loop
         Swapped := False;
         for I in 1 .. N - 1 loop
            if time_to_stop(I) > time_to_stop(I + 1) then
               Swap(time_to_stop, I, I + 1);
               Swap(ID, I, I + 1);
               Swapped := True;
            end if;
         end loop;
      end loop;
   end Sort;

   task body break_thread is
      previous_thread_time : Integer;
   begin
      accept Start do
         break_thread.previous_thread_time := 0;
      end Start;

      for i in 1..thread_count loop
         delay Duration(time_to_stop(i)-previous_thread_time);
         flags_for_threads(id(i)) := True;
         previous_thread_time := time_to_stop(i);
         Ada.Text_IO.Put_Line("Thread  " & id(i)'Img & "  ended with time  " & time_to_stop(i)'Img);
      end loop;

   end break_thread;

   task body main_thread is
      id : Integer;
      sum : Long_Long_Integer := 0;
      step : Integer;
      count_of_operations : Long_Long_Integer := 0;
   begin
      accept Start (id: in Integer; step: in Integer) do
         main_thread.id := id;
         main_thread.step := step;

      end Start;
     Ada.Text_IO.Put_Line("Thread  " & id'Img & "  started");
      loop
            sum := sum + Long_Long_Integer(step);
            count_of_operations := count_of_operations + 1;
         exit when flags_for_threads(id);
      end loop;

         Ada.Text_IO.Put_Line("Id:  " & id'Img & "  Sum:  " & sum'Img);
         Ada.Text_IO.Put_Line("Id:  " & id'Img & "  Count_of_operations:  " & count_of_operations'Img);


   end main_thread;


begin
   for i in 1..thread_count loop
      threads(i).Start(i, i * 3);
      ID(i) := i;
      --time_to_stop(i) := (thread_count + 1 - i) * 5;

   end loop;
   Sort;
   --break.Start;
end Main;
