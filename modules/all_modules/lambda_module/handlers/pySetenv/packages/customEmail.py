import boto3
import jinja2

ses = boto3.client('ses')
env = jinja2.Environment(loader=jinja2.FileSystemLoader('.'))

class Email(object):
    def __init__(self, to, subject):
        self.to = to
        self.subject = subject
        self._html = None
        self._text = None
    
    def _render(self, filename, context):
        template = env.get_template(filename)
        return template.render(context)
    
    def html(self, filename, context):
        self._html = self._render(filename, context)
    
    def text(self, filename, context):
        self._text = self._render(filename, context)
    
    def send(self, from_addr=None):
        body = self._html
        
        # if isinstance(self.to, basestring):
        #      self.to = [self.to]
        if not from_addr:
            from_addr = 'vignesh.palanivelr@gmail.com'
        if not self._html and not self._text:
            raise Exception('You must provide a text or html body.')
        if not self._html:
            self._format = 'text'
            body = self._text
        
        return ses.send_email(
            Source=from_addr,
            Destination={'ToAddresses': [self.to]},
            Message={ 'Subject': {  'Data': self.subject,
                                    'Charset': 'UTF-8'
                                },
                      'Body': {
                            'Text': { 'Data': body,
                                      'Charset': 'UTF-8'
                                    },
                            'Html': { 'Data': body,
                                      'Charset': 'UTF-8'
                                    }
                            }
                    }
        )