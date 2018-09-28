import pandas as pd
import argparse
import sys

def print_df(t):
  print('wa-I\twa-C\tsa\tca\tNruns\tNlvls\tph\tpm\trs\trn\tisdom\tF\tL\tC')
  for x, r in t.iterrows():
    print('%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s' % (
        r['wa-I'], r['wa-C'], r['sa'], r['ca'], r['Nruns'], r['Nlvls'],
        r['ph'], r['pm'], r['rs'], r['rn'], r['isdom'], r['F'], r['L'], r['C']))

def runit(args):
  t = pd.read_table(args.file)
  # print(t.head())
  # print("count: %d" % t.count()['L'])

  if args.max_runs > 0:
    t = t[ t['Nruns'] <= args.max_runs]

  if args.print_dom: print('Count before %d' % t.count()['C'])
  t.drop_duplicates(subset='C', keep='first', inplace=True)
  if args.print_dom: print('Count after %d' % t.count()['C'])

  dom_by = {}
  for x, r in t.iterrows():
    dom_by[r['C']] = []

  for x1, r1 in t.iterrows():
    for x2, r2 in t.iterrows():
      if x1 != x2:
        if args.fuzz > 1.0:
          if (r2['wa-I'] > (r1['wa-I'] * args.fuzz) or
              r2['wa-C'] > (r1['wa-C'] * args.fuzz) or
              r2['ph'] > (r1['ph'] * args.fuzz) or
              r2['rs'] > (r1['rs'] * args.fuzz) or
              r2['rn'] > (r1['rn'] * args.fuzz) or
              r2['sa'] > (r1['sa'] * args.fuzz) or
              r2['ca'] > (r1['ca'] * args.fuzz)):
            continue
        else:
          if (r2['wa-I'] > r1['wa-I'] or
              r2['wa-C'] > r1['wa-C'] or
              r2['ph'] > r1['ph'] or
              r2['rs'] > r1['rs'] or
              r2['rn'] > r1['rn'] or
              r2['sa'] > r1['sa'] or
              r2['ca'] > r1['ca']):
            continue

        # r2 dominates r1
        if args.print_dom:
          print('%s dominates %s: (%s : %s, %s : %s, %s : %s, %s : %s, %s : %s, %s : %s, %s : %s' % (
              r2['C'], r1['C'], r2['wa-I'], r1['wa-I'], r2['wa-C'], r1['wa-C'],
              r2['ph'], r1['ph'], r2['rs'], r1['rs'], r2['rn'], r1['rn'],
              r2['sa'], r1['sa'], r2['ca'], r1['ca']))

        if r1['C'] in dom_by[r2['C']]:
          # Undo r1 dominates r2
          if args.print_dom: print('Undo %s dom %s' % (r1['C'], r2['C']))
          dom_by[r2['C']].remove(r1['C'])
        else:
          # Add r2 dominates r1
          dom_by[r1['C']].append([r2['C']])
          
  is_dom = [dom_by.has_key(r1['C']) and len(dom_by[r1['C']]) > 0 for x1, r1 in t.iterrows()]
  t['isdom'] = is_dom
  print_df(t)
  # t2 = t[is_dom]
  # print_df(t2)

def main(argv):
  parser = argparse.ArgumentParser()
  parser.add_argument('--file')
  parser.add_argument('--fuzz', type=float, default=0)
  parser.add_argument('--print_dom', type=int, default=0)
  parser.add_argument('--max_runs', type=int, default=-1)

  args = parser.parse_args(argv)
  runit(args)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
