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

  dominates = {}
  dominated_by = {}

  for x1, r1 in t.iterrows():
    for x2, r2 in t.iterrows():
      if x1 != x2:
        if (r2['wa-I'] <= r1['wa-I'] and
            r2['wa-C'] <= r1['wa-C'] and
            r2['ph'] <= r1['ph'] and
            r2['rs'] <= r1['rs']):

          if (r2['sa'] > args.max_sa * r1['sa'] or
              r2['ca'] > args.max_ca * r1['ca']):
            continue

          if args.print_dom:
            print('%s dominates %s: (%s : %s, %s : %s, %s : %s, %s : %s' % (
                r2['C'], r1['C'], r2['wa-I'], r1['wa-I'],
                r2['wa-C'], r1['wa-C'], r2['ph'], r1['ph'], r2['rs'], r1['rs']))

          if not dominates.has_key(r2['C']):
            dominates[r2['C']] = [r1['C']]
          else:
            dominates[r2['C']].append([r1['C']])

          if not dominated_by.has_key(r1['C']):
            dominated_by[r1['C']] = [r2['C']]
          else:
            dominated_by[r1['C']].append([r2['C']])
          
  is_dom = [dominated_by.has_key(r1['C']) for x1, r1 in t.iterrows()]
  t['isdom'] = is_dom
  print_df(t)
  # t2 = t[is_dom]
  # print_df(t2)

def main(argv):
  parser = argparse.ArgumentParser()
  parser.add_argument('--file')
  parser.add_argument('--max_sa', type=float, default=1.2)
  parser.add_argument('--max_ca', type=float, default=1.2)
  parser.add_argument('--print_dom', type=int, default=0)
  parser.add_argument('--max_runs', type=int, default=-1)

  args = parser.parse_args(argv)
  runit(args)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
