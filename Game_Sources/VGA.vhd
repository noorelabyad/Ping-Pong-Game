

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start :in std_logic;
           restart:in std_logic;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC;
           up_player1 : in std_logic;
           down_player1 : in std_logic;
           up_player2 :in std_logic;
           down_player2 : in std_logic);
end VGA;

architecture Behavioral of VGA is

component Clock_Divider is
port ( clk,reset: in std_logic;
       clock_out: out std_logic);
end component;

signal Clock_Out,draw1,draw2,draw3,drawb1,drawb2,drawb3,drawb4,
drawc1,drawc2,drawc3,drawc4,drawc,drawp1,drawp2,draw11,draw12,draw13,draw14,draw15,
draw21,draw22,draw23,draw24,draw25,drawsb1,drawsb2 : STD_LOGIC;
signal C1,C2,C3,C4,U,R,L,D,win1,win2,game_over,move_ball,new_frame :std_logic:='0';
signal H_Count : integer range 0 to 800 := 0;
signal V_Count : integer range 0 to 525 := 0;
signal x_Pos_1:integer range 0 to 800 := 16;
signal x_Pos_2 :integer range 0 to 800 := 614;
signal y_Pos_1,y_pos_2:integer range 0 to 525 := 210;
signal x_Pos_3 :integer range 0 to 800 :=310;
signal y_Pos_3 :integer range 0 to 525 :=230;
signal x_up :integer range 0 to 800 :=0;
signal y_up :integer range 0 to 525 :=0;
signal x_left :integer range 0 to 800 :=0;
signal y_left :integer range 0 to 525 :=0;
signal x_down :integer range 0 to 800 :=0;
signal y_down :integer range 0 to 525 :=475; 
signal x_right :integer range 0 to 800 :=636;
signal y_right :integer range 0 to 525 :=0;
---------------------
signal x_cup :integer range 0 to 800 :=255;
signal y_cup :integer range 0 to 525 :=175;
signal x_cleft :integer range 0 to 800 :=255;
signal y_cleft :integer range 0 to 525 :=175;
signal x_cdown :integer range 0 to 800 :=255;
signal y_cdown :integer range 0 to 525 :=299;
signal x_cright :integer range 0 to 800 :=379;
signal y_cright :integer range 0 to 525 :=175;

signal x_c :integer range 0 to 800 :=317;
signal y_c :integer range 0 to 525 :=0;
-----------------------------------------------

signal y11,y12,y13,y14,y15,y21,y22,y23,y24,y25 :integer range 0 to 525 :=62;
signal x11 :integer range 0 to 800 :=63;
signal x12 :integer range 0 to 800 :=108;
signal x13 :integer range 0 to 800 :=153;
signal x14 :integer range 0 to 800 :=198;
signal x15 :integer range 0 to 800 :=243;

signal x21 :integer range 0 to 800 :=350;
signal x22 :integer range 0 to 800 :=395;
signal x23 :integer range 0 to 800 :=440;
signal x24 :integer range 0 to 800 :=485;
signal x25 :integer range 0 to 800 :=530;
 

signal score1,score2:integer range 0 to 10:=0;
 
 
 
 
 
 
Type State_type is (S0,S1,S2,S3,Sgameover);
signal Y :State_type:= S3;
signal Z :std_logic_vector (2 downto 0 );
procedure Rod (
    signal x_Cur, y_Cur, x_Pos, y_Pos: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if ((x_Cur > x_Pos and x_Cur < (x_Pos + 10)) and (y_Cur > y_Pos and y_Cur < (y_Pos + 100))) then
        Draw <= '1';
    else
        Draw <= '0';    
    end if;
end procedure;

procedure Ball (
    signal x_Cur, y_Cur, x_Pos, y_Pos: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if ((x_Cur > x_Pos and x_Cur < (x_Pos + 20)) and (y_Cur > y_Pos and y_Cur < (y_Pos + 20))) then
        Draw <= '1';
    else
        Draw <= '0';    
    end if;
end procedure;

procedure length (
    signal x_Cur, y_Cur, x_Pos, y_Pos: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if ((x_Cur > x_Pos and x_Cur < (x_Pos + 4)) and (y_Cur > y_Pos and y_Cur < (y_Pos + 479))) then
        Draw <= '1';
    else
        Draw <= '0';    
    end if;
end procedure;

procedure width (
    signal x_Cur, y_Cur, x_Pos, y_Pos: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if ((x_Cur > x_Pos and x_Cur < (x_Pos + 639)) and (y_Cur > y_Pos and y_Cur < (y_Pos + 4))) then
        Draw <= '1';
    else
        Draw <= '0';    
    end if;
end procedure;
procedure clength (
    signal x_Cur, y_Cur, x_Pos, y_Pos: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if ((x_Cur > x_Pos and x_Cur < (x_Pos + 4)) and (y_Cur > y_Pos and y_Cur < (y_Pos + 128))) then
        Draw <= '1';
    else
        Draw <= '0';    
    end if;
end procedure;

procedure cwidth(
    signal x_Cur, y_Cur, x_Pos, y_Pos: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if ((x_Cur > x_Pos and x_Cur < (x_Pos + 128)) and (y_Cur > y_Pos and y_Cur < (y_Pos + 4))) then
        Draw <= '1';
    else
        Draw <= '0';    
    end if;
end procedure;

procedure score(
    signal x_Cur, y_Cur, x_Pos, y_Pos: in INTEGER; 
    signal Draw: out STD_LOGIC) is
    begin
    if ((x_Cur > x_Pos and x_Cur < (x_Pos + 40)) and (y_Cur > y_Pos and y_Cur < (y_Pos + 10))) then
        Draw <= '1';
    else
        Draw <= '0';    
    end if;
end procedure;




begin
CD : Clock_Divider port map (clk, reset, Clock_Out);

Rod(H_Count,V_count,x_Pos_1,y_Pos_1,draw1);
Rod(H_Count,V_count,x_Pos_2,y_Pos_2,draw2);
Ball(H_Count,V_count,x_Pos_3,y_Pos_3,draw3);
length(H_Count,V_count,x_left,y_left,drawb2);
length(H_Count,V_count,x_right,y_right,drawb4);
width(H_Count,V_count,x_up,y_up,drawb1);
width(H_Count,V_count,x_down,y_down,drawb3);
length(H_Count,V_count,x_c,y_c,drawc);
cwidth(H_Count,V_count,x_cup,y_cup,drawc1);
clength(H_Count,V_count,x_cleft,y_cleft,drawc2);
cwidth(H_Count,V_count,x_cdown,y_cdown,drawc3);
clength(H_Count,V_count,x_cright,y_cright,drawc4);
--------------------------------------------------------
score(H_Count,V_count,x11,y11,draw11);
score(H_Count,V_count,x12,y12,draw12);
score(H_Count,V_count,x13,y13,draw13);
score(H_Count,V_count,x14,y14,draw14);
score(H_Count,V_count,x15,y15,draw15);

score(H_Count,V_count,x21,y21,draw21);
score(H_Count,V_count,x22,y22,draw22);
score(H_Count,V_count,x23,y23,draw23);
score(H_Count,V_count,x24,y24,draw24);
score(H_Count,V_count,x25,y25,draw25);






    
VGA:process (Clock_Out, reset)
begin

if (rising_edge(Clock_Out)) then
    if (H_Count < 800) then
        H_count<=H_count +1;
    else
        H_count<=0;
        if (V_Count < 525) then
            V_count<=V_count +1;
        else
            V_count<=0;
             if (restart ='1') then
                game_over<='0';win1<='0';win2<='0';L<='0';U<='0';R<='0';D<='0';
                C1<='0';C2<='0';C3<='0';C4<='0';
                score1<=0;score2<=0;
                x_Pos_1<=16; y_Pos_1<=210;
                x_Pos_2<=614; y_Pos_2<=210;
                x_Pos_3<=310; y_Pos_3<=230;
                Y<=S3;
            end if;
            ---------------------------------
           if start = '1' then 
                if (up_player1 ='1') then
                    if(y_Pos_1>4) then
                        y_Pos_1<=y_Pos_1 -5;
                    else
                        y_Pos_1<=y_Pos_1;
                    end if;
                end if;
                if (down_player1 ='1') then
                    if(y_Pos_1<374) then
                        y_Pos_1<=y_Pos_1 +5;
                    else
                        y_Pos_1<=y_Pos_1;
                    end if;
                end if;
                -----------------------------------
                if (up_player2 ='1') then
                    if(y_Pos_2>4) then
                        y_Pos_2<=y_Pos_2 -5;
                    end if;
                end if;
                if (down_player2 ='1') then
                    if(y_Pos_2<374) then
                        y_Pos_2<=y_Pos_2+ 5;
                    end if;
                end if;
                ------------------------------------
          
                if Y=S0 --upright 
                then 
                    y_Pos_3<=y_Pos_3 - 5;
                    x_Pos_3<=x_Pos_3 + 5;
                elsif Y=S1 --downright
                then
                    y_Pos_3<=y_Pos_3 + 5;
                    x_Pos_3<=x_Pos_3 + 5;
                elsif Y=S2 --upleft 
                then
                    y_Pos_3<=y_Pos_3 - 5;
                    x_Pos_3<=x_Pos_3 - 5;
                elsif Y=S3 --downleft
                then
                    y_Pos_3<=y_Pos_3 + 5;
                    x_Pos_3<=x_Pos_3 - 5;
                else
                    y_Pos_3<=y_Pos_3;
                    x_Pos_3<=x_Pos_3;
                end if;
              
                -----------------------------------------------
               
               U <= '0'; L <= '0';D <= '0'; R <= '0';
               C1 <= '0'; C2 <= '0';C3 <= '0'; C4 <= '0';
               
               if y_Pos_3 = 5 then
                    if x_Pos_3 = 5 or (x_Pos_3 = 30 and (y_Pos_3>(y_Pos_1-20 ) and y_Pos_3<(y_Pos_1 +100)))then
                       C1<='1';
                    elsif x_Pos_3 = 615 or (x_Pos_3 = 590 and (y_Pos_3>(y_Pos_2-20 ) and y_Pos_3<(y_Pos_2 +100)) )then
                       C2<='1';
                    else
                       U<='1';
                    end if;
               elsif y_Pos_3 = 455 then
                    if x_Pos_3 = 5 or (x_Pos_3 = 30 and (y_Pos_3>(y_Pos_1-20 ) and y_Pos_3<(y_Pos_1 +100) )) then
                       C4<='1';
                    elsif x_Pos_3 = 615 or (x_Pos_3 = 590 and (y_Pos_3>(y_Pos_2-20 ) and y_Pos_3<(y_Pos_2 +100)))then
                       C3<='1';
                    else
                       D<='1';
                    end if;
               elsif (x_Pos_3 = 590 and (y_Pos_3>(y_Pos_2-20 ) and y_Pos_3<(y_Pos_2 +100)) ) or 
                    (x_Pos_3=615 and score1<9)then 
                   R<='1';
               elsif (x_Pos_3 = 30 and (y_Pos_3>(y_Pos_1-20 ) and y_Pos_3<(y_Pos_1 +100) )) or 
                    (x_Pos_3=5 and score2<9)then 
                   L<='1';
               
               end if;
               
               
               
               
               if (x_Pos_3=5 ) then
                   score2 <= score2+1;
                   if score2= 9 then
                     game_over<='1';
                     win2 <= '1';
                   end if;
               elsif x_Pos_3=615 then
                    score1 <= score1+1;
                    if score1= 9 then
                      game_over<='1';
                      win1 <= '1';
                    end if;
               end if;  
              
                case Y is
                    when S0 => if game_over ='1' then Y<= Sgameover; 
                                elsif U = '1' then Y<= S1; 
                                elsif R = '1' then Y<= S2; 
                                elsif C2 = '1' then Y<=S3;--C2<='0';
                                else Y<= S0; end if;
                    when S1 => if game_over ='1' then Y<= Sgameover; 
                                elsif D = '1' then Y<= S0;
                                elsif R = '1' then Y<= S3; 
                                elsif C3 = '1' then Y<=S2;--C3<='0';
                                else Y<= S1; end if;
                    when S2 => if game_over ='1' then Y<= Sgameover; 
     
                                elsif U = '1' then Y<= S3;
                                elsif L = '1' then Y<= S0;
                                elsif C1 = '1' then Y<=S1;--C1<='0';
                                else Y<= S2; end if;
                    when S3 => if game_over ='1' then Y<= Sgameover; 
                                
                                elsif L = '1' then Y<= S1;
                                elsif D = '1' then Y<= S2; 
                                elsif C4 = '1' then Y<=S0;--C4<='0';
                                else Y<= S3; end if;
                    when Sgameover => Y<= Sgameover;
                    
                end case;
           end if;
        end if;
    end if;
    ----------------------------------------
    if (H_Count > 655 and H_Count < 752)then
        Hsync<='0';
    else
        Hsync<='1';
    end if;
    if (V_Count > 489 and V_Count < 492)then
        Vsync<='0';
    else
        Vsync<='1';
    end if;
    ----------------------------------------

    if ( win1='1'or win2='1') then
        if H_count>=0 and H_count <=639 and V_count>=0 and V_count <=479 then
            if win1='1' then
                vgaRed<="1011";
                vgaGreen<="0000";
                vgaBlue<="1011";
            elsif  win2='1' then
                vgaRed<="0000";
                vgaGreen<="1011";
                vgaBlue<="1011";
             end if;
        else 
            vgaRed<="0000";
            vgaGreen<="0000";
            vgaBlue<="0000";
        end if;
    else
        if draw1 ='1' or 
        (draw11 ='1' and score1>=2) or (draw12 ='1'and score1>=4)or (draw13 ='1' and score1>=6)
        or (draw14 ='1' and score1 >=8)or (draw15 ='1'and score1 =10)
        then
            vgaRed<="1011";
            vgaGreen<="0000";
            vgaBlue<="1011";
        end if;
        
        if  draw2 ='1' or 
        (draw21 ='1' and score2>=2) or (draw22 ='1'and score2>=4)or (draw23 ='1' and score2>=6)
        or (draw24 ='1' and score2 >=8)or (draw25 ='1'and score2 =10)
        then
            vgaRed<="0000";
            vgaGreen<="1011";
            vgaBlue<="1011";
        end if;
        if  draw3 ='1' then
            vgaRed<="1101";
            vgaGreen<="1101";
            vgaBlue<="1101";
        end if;
    
        if  drawb1 ='1' or drawb2 ='1' or drawb3 ='1' or drawb4 ='1' or drawsb1 ='1' or drawsb2 ='1'
        or drawc1 ='1' or drawc2 ='1' or drawc3 ='1' or drawc4 ='1' or drawc ='1' or
        (draw21 ='1' and score2<2) or (draw22 ='1'and score2<4)or (draw23 ='1' and score2<6)
        or (draw24 ='1' and score2 <8)or (draw25 ='1'and score2 <10) or
        (draw11 ='1' and score1<2) or (draw12 ='1'and score1<4)or (draw13 ='1' and score1<6)
        or (draw14 ='1' and score1 <8)or (draw15 ='1'and score1 <10)
         then
            vgaRed<="1111";
            vgaGreen<="1111";
            vgaBlue<="1111";
        end if;
    end if;
    
    if draw1 ='0' and draw2 ='0' and draw3 ='0' and drawb1 ='0' and drawb4 ='0' and drawb3 ='0' and drawb2 ='0'
    and drawc1 ='0' and drawc2 ='0' and drawc3 ='0' and drawc4 ='0' and drawc ='0' 
    and draw21 ='0' and draw22 ='0'and draw23 ='0'and draw24 ='0'and draw25 ='0' and 
    draw11 ='0' and draw12 ='0'and draw13 ='0'and draw14 ='0'and draw15 ='0'
    then
        vgaRed<="0000";
        vgaGreen<="0000";
        vgaBlue<="0000";
    end if;
    ---------------------------------------------
             
end if;
end process;


end Behavioral;
----------------------------------------------------------------------------
