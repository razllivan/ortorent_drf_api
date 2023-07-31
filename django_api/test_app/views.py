from test_app.models import TestModel
from test_app.serializers import TestSerializer
from rest_framework.viewsets import ModelViewSet


class TestList(ModelViewSet):
    queryset = TestModel.objects.all()
    serializer_class = TestSerializer
