env.DIST = 'xenial'
env.PWD_BIND = '/workspace'

fancyNode('master') {
  stage('release') {
    checkout scm
    copyArtifacts excludes: 'ulogs/runtime-snap.json', filter: 'ulogs/*-snap.json', fingerprintArtifacts: true, flatten: true, projectName: 'openqa_snap/bomber/candidate'
    sh 'ls'
    sh 'mv *.json snap.json'
    withCredentials([file(credentialsId: 'snapcraft.cfg', variable: 'SNAPCRAFT_CFG')]) {
      sh 'cp $SNAPCRAFT_CFG snapcraft.cfg'
      sh '~/tooling/nci/contain.rb /workspace/release.rb'
    }
  }
}

def fancyNode(label = null, body) {
  node(label) {
    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
      wrap([$class: 'TimestamperBuildWrapper']) {
        finally_cleanup { finally_chown { body() } }
      }
    }
  }
}

def finally_chown(body) {
  try {
    body()
  } finally {
    sh '~/tooling/nci/contain.rb chown -R jenkins .'
  }
}

def finally_cleanup(body) {
  try {
    body()
  } finally {
    if (!env.NO_CLEAN) {
      cleanWs()
    }
  }
}
