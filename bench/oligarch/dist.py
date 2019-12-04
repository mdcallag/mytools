"""
Copyright (c) 2019, Mark Callaghan
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"""

import argparse
import sys
import scipy.special

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('--bankrupt_at', type=int, default=10,
                      help='User is bankrupt when budget drops to this amount '\
                           'or the budget is less than the fixed bet amount')
  parser.add_argument('--bet_initial', type=int, default=10,
                      help='Initial bet for let it ride strategy')
  parser.add_argument('--bet_fixed', type=int, default=10,
                      help='Bet per round for fixed strategy')
  parser.add_argument('--num_bets', type=int, default=10,
                      help='Number of bets to make')
  parser.add_argument('--win_percent', type=float, default=20.0,
                      help='Gain this percent of your bet on win.')
  parser.add_argument('--lose_percent', type=float, default=20.0,
                      help='Lose this percent of your bet on loss.')
  parser.add_argument('--debug', type=int, default=0,
                      help='Set to 1 to get more output')

  args = parser.parse_args()

  if args.bet_fixed <= 0:
    print('--bet_fixed must be > 0')
    sys.exit(-1)
  elif args.bet_initial <= 0:
    print('--bet_initial must be > 0')
    sys.exit(-1)
  elif args.num_bets <= 0:
    print('--num_bets must be > 0')
    sys.exit(-1)
  elif args.win_percent <= 0:
    print('--win_percent must be > 0')
    sys.exit(-1)
  elif args.lose_percent <= 0:
    print('--lose_percent must be > 0')
    sys.exit(-1)

  win_fractions, ways_to_win = get_dist(args)
  win_lir, ewin_lir, e_lir = letitride(args, win_fractions)
  win_fix, ewin_fix, e_fix = fixed(args, win_fractions)
  print('E(lir, rix) = %.3f %.3f' % (e_lir, e_fix))
  print('#Win\tWin%\t\tW(lir)\tW(fix)\tEW(lir)\tEW(fix)')
  for i in range(args.num_bets+1):
    print('%d\t%.3f\t\t%.3f\t%.3f\t%.3f\t%.3f' % (
          i, 100*win_fractions[i],
          win_lir[i], win_fix[i],
          ewin_lir[i], ewin_fix[i]))

def get_dist(args):
  ways_to_win = []
  win_fractions = []
  for i in range(args.num_bets + 1):
    ways_to_win.append(scipy.special.binom(args.num_bets, i))
  nways = sum(ways_to_win)
  for i in range(args.num_bets + 1):
    win_fractions.append(ways_to_win[i] / float(nways))
  return win_fractions, ways_to_win

def letitride(args, win_fractions):
  result = []
  eresult = []
  win_f = (100.0 + args.win_percent) / 100.0
  lose_f = (100.0 - args.lose_percent) / 100.0
  for i in range(args.num_bets + 1):
    amount = (win_f ** i) * (lose_f ** (args.num_bets - i)) * args.bet_initial
    amount -= args.bet_initial
    result.append(amount)
    eresult.append(amount * win_fractions[i])
  eval = sum(eresult)
  return result, eresult, eval

def fixed(args, win_fractions):
  result = []
  eresult = []
  for i in range(args.num_bets + 1):
    win  = (args.win_percent / 100.0) * args.bet_fixed * i
    lose = (args.lose_percent / 100.0) * args.bet_fixed * (args.num_bets - i)
    result.append(win - lose)
    eresult.append((win-lose) * win_fractions[i])
  eval = sum(eresult)
  return result, eresult, eval

if __name__ == "__main__":
        main()

