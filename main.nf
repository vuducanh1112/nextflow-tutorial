params.str = 'Hello world!'

process splitLetters {

  require(["#!/bin/bash\nsleep 3", "#!/bin/bash\necho hi"])

//  promise(["#!/bin/bash\necho hihi"])
  promise([FOR_ALL("f", ITER("*.fastq"), 
		{ f -> 
			IF_THEN(
				NOT(
					EQUAL(
						NUM("\$(( \$(wc -l $f | cut -d' ' -f1)/4*4 ))"), 
						NUM("\$(wc -l $f | cut -d' ' -f1)")
					)
				), 
				"exit 1"
			)
		}
	)])


  output:
    path 'chunk_*'

  """
  sleep 2
  printf '${params.str}' | split -b 6 - chunk_
  """
}

process convertToUpper {
  require(["#!/bin/bash\necho yo"])

//  promise(["foo"])

  input:
    path x
  output:
    stdout

  """
  sleep 2
  cat $x | tr '[a-z]' '[A-Z]'
  """
}

workflow {
  splitLetters | flatten | convertToUpper | view { it.trim() }
}
