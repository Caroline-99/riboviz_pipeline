process CUTADAPT {

    tag "${meta.id}"
    label 'process_medium'

    conda "bioconda::cutadapt=3.4"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/cutadapt:3.4--py39h38f01e4_1' :
        'biocontainers/cutadapt:3.4--py39h38f01e4_1' }"

    input:
    tuple val(meta), path(sample_fq)

    output:
    tuple val(meta), path('*.fq'), emit: reads
    tuple val(meta), path('*_cutadapt.log'), emit: log
    path "versions.yml", emit: versions

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def single_end = task.ext.single_end ?: false
    def trimmed = single_end ? "-o ${prefix}_trim.fq" : "-o ${prefix}_1.trim.fq -p ${prefix}_2.trim.fq"
    """
    cutadapt \\
        --cores $task.cpus --trim-n -O 1 -m 5 -a ${params.adapters} \\
        $trimmed \\
        ${sample_fq} \\
        > ${prefix}.cutadapt.log
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cutadapt: \$(cutadapt --version)
    END_VERSIONS
    """
}

